package Spielmeister.Spell.Platform.Private.Graphics.DisplayList {

	import Spielmeister.Spell.Platform.Private.Graphics.StateStack
	import Spielmeister.Spell.Platform.Private.Graphics.StateStackElement

	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.Shape
	import flash.display.Stage
	import flash.geom.ColorTransform
	import flash.geom.Matrix
	import flash.geom.Point
	import flash.geom.Rectangle
	import flash.external.ExternalInterface

	import net.richardlord.coral.Matrix3d
	import net.richardlord.coral.Vector3d


	public class DisplayListContext {
		private var stage : Stage
		private var width : uint
		private var height : uint
		private var id : String
		private var colorBuffer : Bitmap
		private var clearColor : uint

		private var stateStack : StateStack = new StateStack( 32 )
		private var currentState : StateStackElement

		private var transferMatrix : Matrix = new Matrix()
		private var tmpShape : Shape        = new Shape()

		// view space to screen space transformation matrix
		private var viewToScreen : Matrix3d = new Matrix3d()

		// world space to view space transformation matrix
		private var worldToView : Matrix3d = new Matrix3d()

		// accumulated transformation world space to screen space transformation matrix
		private var worldToScreen : Matrix3d = new Matrix3d()

		// transformation from screen space to world space
		private var screenToWorld : Matrix3d = new Matrix3d()

		// temporaries
		private var tmpMatrix : Matrix3d = new Matrix3d()
		private var tmpVector : Vector3d = new Vector3d()


		public function DisplayListContext( stage : Stage, id : String, width : uint, height: uint ) {
			this.stage  = stage
			this.width  = width
			this.height = height
			this.id     = id
			clearColor  = 0x000000

			// setting up the color buffer
			colorBuffer = new Bitmap()
			colorBuffer.bitmapData = new BitmapData(
				this.width,
				this.height,
				false,
				clearColor
			)

			this.stage.addChild( colorBuffer )

			this.stateStack.pushState()
			this.currentState = this.stateStack.popState()


			// initializing
			viewport( 0, 0, this.width, this.height )

			// world space to view space matrix
			var cameraWidth  = width,
				cameraHeight = height

			ortho(
				-cameraWidth / 2,
				cameraWidth / 2,
				-cameraHeight / 2,
				cameraHeight / 2,
				worldToView
			)

			worldToView.prependTranslation( -cameraWidth / 2, -cameraHeight / 2, 0 ) // WATCH OUT: apply inverse translation for camera position

			updateWorldToScreen( viewToScreen, worldToView )
		}


		private function clampToUnit( value : Number ) : Number {
			return Math.min( 1.0, Math.max( value, 0.0 ) )
		}


		private function createColorValue( vec : Array ) : uint {
			var color : uint = 0

			for( var i : int = 0; i < 3; i++ ) {
				color += uint( clampToUnit( vec[ i ] ) * 255 ) << ( ( 2 - i ) * 8 )
			}

			return color
		}


		private function ortho( left : Number, right : Number, bottom : Number, top : Number, dest : Matrix3d ) : void {
			var rl : Number = ( right - left ),
				tb : Number = ( top - bottom )

			dest.n11 = 2 / rl
			dest.n21 = 0
			dest.n31 = 0
			dest.n41 = 0
			dest.n12 = 0
			dest.n22 = 2 / tb
			dest.n32 = 0
			dest.n32 = 0
			dest.n13 = 0
			dest.n23 = 0
			dest.n33 = 1
			dest.n43 = 0
			dest.n14 = -( left + right ) / rl
			dest.n24 = -( top + bottom ) / tb
			dest.n34 = 0
			dest.n44 = 1
		}


		/**
		 * Updates the world to screen matrix.
		 *
		 * @param viewToScreen
		 * @param worldToView
		 */
		private function updateWorldToScreen( viewToScreen : Matrix3d, worldToView : Matrix3d ) : void {
			var worldToScreen = this.worldToScreen

			worldToScreen.reset()
			worldToScreen.prepend( viewToScreen )
			worldToScreen.prepend( worldToView )
			worldToScreen.inverse( this.screenToWorld )
		}

		public function setColor( vec : Array ) : void {
			currentState.color = createColorValue( vec )
		}


		public function setGlobalAlpha( u : Number ) : void {
			currentState.opacity = clampToUnit( u )
		}


		public function setClearColor( vec : Array ) : void {
			clearColor = createColorValue( vec )
		}


		public function save() : void {
			currentState = stateStack.pushState()
		}


		public function restore() : void {
			currentState = stateStack.popState()
		}


		public function scale( vec : Array ) : void {
			currentState.matrix.prependScale( vec[ 0 ], vec[ 1 ], 1 )
		}


		public function translate( vec : Array ) : void {
			currentState.matrix.prependTranslation( vec[ 0 ], vec[ 1 ], 0 )
		}


		public function rotate( u : Number ) : void {
			currentState.matrix.prependRotation( u, Vector3d.Z_AXIS )
		}


		public function drawTexture( texture : Object, destinationPosition : Array, destinationDimensions : Array, textureMatrix : Array ) : void {
			var dx : Number = destinationPosition[ 0 ],
				dy : Number = destinationPosition[ 1 ],
				dw : Number = destinationDimensions[ 0 ],
				dh : Number = destinationDimensions[ 1 ]

			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )
			tmpMatrix.prependScale( -1, 1, 1 )
			tmpMatrix.prependTranslation( 0, -dh, 0 )

			// correcting scale
			tmpMatrix.prependScale( dw / texture.dimensions[ 0 ], dh / texture.dimensions[ 1 ], 1 )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24


			var colorTransform : ColorTransform = null
			if( currentState.opacity < 1 ) {
				colorTransform = new ColorTransform( 1, 1, 1, currentState.opacity )
			}


			colorBuffer.bitmapData.draw(
				texture.privateBitmapDataResource,
				transferMatrix,
				colorTransform,
				null,
				null,
				true
			)
		}


		public function drawSubTexture(
			texture : Object,
			sourcePosition : Array,
			sourceDimensions : Array,
			destinationPosition : Array,
			destinationDimensions : Array
		) : void {
			var sx : Number = sourcePosition[ 0 ],
				sy : Number = sourcePosition[ 1 ],
				sw : Number = sourceDimensions[ 0 ],
				sh : Number = sourceDimensions[ 1 ],
				dx : Number = destinationPosition[ 0 ],
				dy : Number = destinationPosition[ 1 ],
				dw : Number = destinationDimensions[ 0 ],
				dh : Number = destinationDimensions[ 1 ]

			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )
			tmpMatrix.prependScale( -1, 1, 1 )
			tmpMatrix.prependTranslation( 0, -dh, 0 )

			// correcting scale
			tmpMatrix.prependScale( dw / sw, dh / sh, 1 )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24


			var colorTransform : ColorTransform = null
			if( currentState.opacity < 1 ) {
				colorTransform = new ColorTransform( 1, 1, 1, currentState.opacity )
			}

			/**
			 * Yes, your are eyes are not deceiving you. This method creates a temporary BitmapData instance in order to perform source texture cropping
			 * a.k.a. "a poor copy of a texture matrix". This is how it's done on htrae!
			 */
			var tmpBitmapData : BitmapData = new BitmapData( sw, sh, true, 0x00000000 )
			tmpBitmapData.copyPixels( texture.privateBitmapDataResource, new Rectangle( sx, sy, sw, sh ), new Point( 0, 0 ) )

			colorBuffer.bitmapData.draw(
				tmpBitmapData,
				transferMatrix,
				colorTransform,
				null,
				null,
				true
			)
		}


		public function fillRect( dx : Number, dy : Number, dw : Number, dh : Number ) : void {
			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )
			tmpMatrix.prependScale( -1, 1, 1 )
			tmpMatrix.prependTranslation( 0, -dh, 0 )

			transferMatrix.a  = tmpMatrix.n11
			transferMatrix.b  = tmpMatrix.n21
			transferMatrix.c  = tmpMatrix.n12
			transferMatrix.d  = tmpMatrix.n22
			transferMatrix.tx = tmpMatrix.n14
			transferMatrix.ty = tmpMatrix.n24


			tmpShape.graphics.clear()
			tmpShape.graphics.beginFill( currentState.color )
			tmpShape.graphics.drawRect( 0, 0, dw, dh )
			tmpShape.graphics.endFill()


			colorBuffer.bitmapData.draw(
				tmpShape,
				transferMatrix,
				null
			)
		}

		public function transform( matrix : Array ) : void {
			currentState.matrix.prepend(
				new Matrix3d(
					matrix[ 0 ],
					matrix[ 1 ],
					0,
					matrix[ 2 ],
					matrix[ 3 ],
					matrix[ 4 ],
					0,
					matrix[ 5 ],
					0,
					0,
					1,
					0,
					matrix[ 6 ],
					matrix[ 7 ],
					0,
					matrix[ 8 ]
				)
			)
		}

		public function setTransform( matrix : Array ) : void {
			var destination = currentState.matrix

			destination.n11 = matrix[ 0 ]
			destination.n21 = matrix[ 1 ]
			destination.n41 = matrix[ 2 ]
			destination.n12 = matrix[ 3 ]
			destination.n22 = matrix[ 4 ]
			destination.n42 = matrix[ 5 ]
			destination.n14 = matrix[ 6 ]
			destination.n24 = matrix[ 7 ]
			destination.n44 = matrix[ 8 ]
		}

		public function setViewMatrix( matrix : Array ) : void {
			worldToView.n11 = matrix[ 0 ]
			worldToView.n21 = matrix[ 1 ]
			worldToView.n12 = matrix[ 3 ]
			worldToView.n22 = matrix[ 4 ]
			worldToView.n14 = matrix[ 6 ]
			worldToView.n24 = matrix[ 7 ]

			updateWorldToScreen( viewToScreen, worldToView )
		}

		public function viewport( dx : Number, dy : Number, dw : Number, dh : Number ) : void {
			viewToScreen.n11 = dw * 0.5
			viewToScreen.n22 = dh * 0.5 * -1 // mirroring y-axis
			viewToScreen.n14 = dx + dw * 0.5
			viewToScreen.n24 = dy + dh * 0.5

			updateWorldToScreen( viewToScreen, worldToView )
		}

		public function resizeColorBuffer ( newWidth : Number, newHeight : Number ) : void {
			ExternalInterface.call( 'spell_setDimensions', this.id + '-screen', newWidth, newHeight )

			while( stage.numChildren ) {
				stage.removeChildAt( 0 )
			}

			// setting up the color buffer
			colorBuffer = new Bitmap()
			colorBuffer.bitmapData = new BitmapData(
				newWidth,
				newHeight,
				false,
				clearColor
			)

			stage.addChild( colorBuffer )
		}


		public function clear() : void {
			tmpShape.graphics.clear()
			tmpShape.graphics.beginFill( clearColor )
			tmpShape.graphics.drawRect( 0, 0, colorBuffer.width, colorBuffer.height )
			tmpShape.graphics.endFill()

			transferMatrix.identity()

			colorBuffer.bitmapData.draw(
				tmpShape,
				transferMatrix,
				null
			)
		}


		public function createTexture( bitmapData : BitmapData ) : Object {
			return {
				/**
				 * public
				 */
				dimensions : [ bitmapData.width, bitmapData.height ],

				/**
				 * private
				 *
				 * This is an implementation detail of the class. If you write code that depends on this you better know what you are doing.
				 */
				privateBitmapDataResource: bitmapData
			}
		}


		public function getConfiguration() : Object {
			return {
				type   : "display-list",
				width  : width,
				height : height
			}
		}


		public function transformScreenToWorld( vec : Array ) : Array {
			tmpVector.x = vec[ 0 ]
			tmpVector.y = vec[ 1 ]

			this.screenToWorld.transformVector( tmpVector, tmpVector )

			return [
				tmpVector.x - this.width / 2,
				tmpVector.y + this.height / 2
			]
		}
	}
}
