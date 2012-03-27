package Spielmeister.Spell.Platform.Private.Graphics.DisplayList {

	import Spielmeister.Spell.Platform.Private.Graphics.StateStack
	import Spielmeister.Spell.Platform.Private.Graphics.StateStackElement

	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.Shape
	import flash.geom.ColorTransform
	import flash.geom.Matrix
	import flash.geom.Matrix3D
	import flash.geom.Vector3D

	import mx.core.IChildList

	import net.richardlord.coral.Matrix3d
	import net.richardlord.coral.Vector3d


	public class DisplayListContext {
		private var container : IChildList
		private var width : uint
		private var height : uint
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

		// temporary Matrix
		private var tmpMatrix : Matrix3d = new Matrix3d()


		public function DisplayListContext( container : IChildList, width : uint, height: uint ) {
			this.container = container
			this.width = width
			this.height = height
			clearColor = 0x000000

			// setting up the color buffer
			colorBuffer = new Bitmap()
			colorBuffer.bitmapData = new BitmapData(
				this.width,
				this.height,
				false,
				clearColor
			)

			container.addChild( colorBuffer )

			this.currentState = this.stateStack.getTop()


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
				0,
				1000,
				worldToView
			)

			worldToView.prependTranslation( -cameraWidth / 2, -cameraHeight / 2, 0 ) // WATCH OUT: apply inverse translation for camera position

			resetAndPrependToMatrix( worldToScreen, viewToScreen, worldToView )
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


		private function ortho( left : Number, right : Number, bottom : Number, top : Number, near : Number, far : Number, dest : Matrix3d ) : void {
			var rl : Number = ( right - left ),
				tb : Number = ( top - bottom ),
				fn : Number = ( far - near )

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
			dest.n33 = -2 / fn
			dest.n43 = 0
			dest.n14 = -( left + right ) / rl
			dest.n24 = -( top + bottom ) / tb
			dest.n34 = -( far + near ) / fn
			dest.n44 = 1
		}


		/**
		 * Sets the destination matrix to the identity and appends the two transformation matrices to it.
		 *
		 * @param destination
		 * @param matrix1
		 * @param matrix2
		 */
		private function resetAndPrependToMatrix( destination : Matrix3d, matrix1 : Matrix3d, matrix2 : Matrix3d ) : void {
			destination.reset()
			destination.prepend( matrix1 )
			destination.prepend( matrix2 )
		}


		public function setFillStyleColor( vec : Array ) : void {
			currentState.color = createColorValue( vec )
		}


		public function setGlobalAlpha( u : Number ) : void {
			currentState.opacity = clampToUnit( u )
		}


		public function setClearColor( vec : Array ) : void {
			clearColor = createColorValue( vec )
		}


		public function save() : void {
			stateStack.pushState()
			currentState = stateStack.getTop()
		}


		public function restore() : void {
			stateStack.popState()
			currentState = stateStack.getTop()
		}


		public function scale( vec : Array ) : void {
			currentState.matrix.prependScale( vec[ 0 ], vec[ 1 ], 1 )
		}


		public function translate( vec : Array ) : void {
			currentState.matrix.prependTranslation( vec[ 0 ], vec[ 1 ], 0 )
		}


		public function rotate( u : Number ) : void {
			currentState.matrix.prependRotation( -u, Vector3d.Z_AXIS )
		}


		public function drawTexture( texture : Object, dx : Number, dy : Number, dw : Number, dh : Number ) : void {
			tmpMatrix.assign( worldToScreen )
			tmpMatrix.prepend( currentState.matrix )

			// rotating the image so that it is not upside down
			tmpMatrix.prependTranslation( dx, dy, 0 )
			tmpMatrix.prependRotation( Math.PI, Vector3d.Z_AXIS )
			tmpMatrix.prependScale( -1, 1, 1 )
			tmpMatrix.prependTranslation( 0, -dh, 0 )

			// correcting scale
			tmpMatrix.prependScale( dw / texture.width, dh / texture.height, 1 )

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
					matrix[ 2 ],
					matrix[ 3 ],
					matrix[ 4 ],
					matrix[ 5 ],
					matrix[ 6 ],
					matrix[ 7 ],
					matrix[ 8 ],
					matrix[ 9 ],
					matrix[ 10 ],
					matrix[ 11 ],
					matrix[ 12 ],
					matrix[ 13 ],
					matrix[ 14 ],
					matrix[ 15 ]
				)
			)
		}

		public function setTransform( matrix : Array ) : void {
			var destination = currentState.matrix

			destination.n11 = matrix[ 0 ]
			destination.n21 = matrix[ 1 ]
			destination.n31 = matrix[ 2 ]
			destination.n41 = matrix[ 3 ]
			destination.n12 = matrix[ 4 ]
			destination.n22 = matrix[ 5 ]
			destination.n32 = matrix[ 6 ]
			destination.n32 = matrix[ 7 ]
			destination.n13 = matrix[ 8 ]
			destination.n23 = matrix[ 9 ]
			destination.n33 = matrix[ 10 ]
			destination.n43 = matrix[ 11 ]
			destination.n14 = matrix[ 12 ]
			destination.n24 = matrix[ 13 ]
			destination.n34 = matrix[ 14 ]
			destination.n44 = matrix[ 15 ]
		}

		public function setViewMatrix( matrix : Array ) : void {
			worldToView.n11 = matrix[ 0 ]
			worldToView.n21 = matrix[ 1 ]
			worldToView.n12 = matrix[ 4 ]
			worldToView.n22 = matrix[ 5 ]
			worldToView.n14 = matrix[ 12 ]
			worldToView.n24 = matrix[ 13 ]

			resetAndPrependToMatrix( worldToScreen, viewToScreen, worldToView )
		}

		public function viewport( dx : Number, dy : Number, dw : Number, dh : Number ) : void {
			viewToScreen.n11 = dw * 0.5
			viewToScreen.n22 = dh * 0.5 * -1 // mirroring y-axis
			viewToScreen.n14 = dx + dw * 0.5
			viewToScreen.n24 = dy + dh * 0.5

			resetAndPrependToMatrix( worldToScreen, viewToScreen, worldToView )
		}

		public function resizeColorBuffer ( newWidth : Number, newHeight : Number ) : void {
			while( container.numChildren ) {
				container.removeChildAt( 0 )
			}

			// setting up the color buffer
			colorBuffer = new Bitmap()
			colorBuffer.bitmapData = new BitmapData(
				newWidth,
				newHeight,
				false,
				clearColor
			)

			container.addChild( colorBuffer )
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
				width  : bitmapData.width,
				height : bitmapData.height,

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
	}
}
