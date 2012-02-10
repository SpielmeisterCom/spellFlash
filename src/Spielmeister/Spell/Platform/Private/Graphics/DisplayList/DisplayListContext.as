package Spielmeister.Spell.Platform.Private.Graphics.DisplayList {

	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.DisplayObject
	import flash.display.Shape
	import flash.display.Sprite
	import flash.geom.ColorTransform
	import flash.geom.Matrix
	import flash.geom.Matrix3D
	import flash.geom.Vector3D


	public class DisplayListContext {
		private var root : Sprite
		private var width : uint
		private var height : uint
		private var colorBuffer : Bitmap
		private var clearColor : uint

		private var stateStackDepth : uint   = 32
		private var stateStack : Array       = new Array( stateStackDepth )
		private var currentStateIndex : uint = 0
		private var tmpMatrix : Matrix       = new Matrix()
		private var tmpShape : Shape         = new Shape()


		public function DisplayListContext( _root : DisplayObject, width : uint, height: uint ) {
			this.root = Sprite( _root )
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

			root.addChild( colorBuffer )


			// initializing state stack
			for( var i : int = 0; i < stateStack.length; i++ ) {
				stateStack[ i ] = createDefaultState()
			}
		}


		private static function clampToUnit( value : Number ) : Number {
			return Math.min( 1.0, Math.max( value, 0.0 ) )
		}


		private function createState( opacity : Number, fillStyleColor : Array, transformationMatrix : Matrix3D ) : Object {
			return {
				opacity         : opacity,
				color           : fillStyleColor,
				modelViewMatrix : transformationMatrix
			}
		}


		private function createDefaultState() : Object {
			var opacity : Number         = 1.0
			var fillStyleColor : Array   = [ 1.0, 1.0, 1.0, 1.0 ]
			var modelViewMatrix : Matrix3D = new Matrix3D()

			return createState(
				opacity,
				fillStyleColor,
				modelViewMatrix
			)
		}


		private function copyState( source : Object, target : Object ) : void {
			target.opacity = source.opacity

			target.color[ 0 ] = source.color[ 0 ]
			target.color[ 1 ] = source.color[ 1 ]
			target.color[ 2 ] = source.color[ 2 ]
			target.color[ 3 ] = source.color[ 3 ]

			target.modelViewMatrix.copyFrom( source.modelViewMatrix )
		}


		private function pushState() : void {
			if( currentStateIndex === stateStackDepth -1 ) throw "Maximum state stack depth exceeded."


			copyState(
				stateStack[ currentStateIndex ],
				stateStack[ ++currentStateIndex ]
			)
		}


		private function popState() : void {
			if( currentStateIndex > 0 ) {
				currentStateIndex--
			}
		}


		public function setFillStyleColor( vec : Array ) : void {
			trace( "setFillStyleColor - not yet implemented" )
		}


		public function setGlobalAlpha( u : Number ) : void {
			stateStack[ currentStateIndex ].opacity = clampToUnit( u )
		}


		public function setClearColor( vec : Array ) : void {
			for( var i : int = 0; i < 3; i++ ) {
				clearColor += uint( clampToUnit( vec[ i ] ) * 255 ) << ( ( 2 - i ) * 8 )
			}
		}


		public function save() : void {
			pushState()
		}


		public function restore() : void {
			popState()
		}


		public function scale( vec : Array ) : void {
			stateStack[ currentStateIndex ].modelViewMatrix.prependScale( vec[ 0 ], vec[ 1 ], 1 )
		}


		public function translate( vec : Array ) : void {
			stateStack[ currentStateIndex ].modelViewMatrix.prependTranslation( vec[ 0 ], vec[ 1 ], 0 )
		}


		public function rotate( u : Number ) : void {
			stateStack[ currentStateIndex ].modelViewMatrix.prependRotation( u / Math.PI * 180, Vector3D.Z_AXIS )
		}


		public function clear() : void {
			tmpShape.graphics.clear()
			tmpShape.graphics.beginFill( clearColor )
			tmpShape.graphics.drawRect( 0, 0, colorBuffer.width, colorBuffer.height )
			tmpShape.graphics.endFill()

			tmpMatrix.identity()

			colorBuffer.bitmapData.draw(
				tmpShape,
				tmpMatrix,
				null
			)
		}


		public function drawTexture( texture : Object, x : Number, y : Number ) : void {
			tmpMatrix.identity()
			tmpMatrix.a  = stateStack[ currentStateIndex ].modelViewMatrix.rawData[ 0 ]
			tmpMatrix.b  = stateStack[ currentStateIndex ].modelViewMatrix.rawData[ 1 ]
			tmpMatrix.c  = stateStack[ currentStateIndex ].modelViewMatrix.rawData[ 4 ]
			tmpMatrix.d  = stateStack[ currentStateIndex ].modelViewMatrix.rawData[ 5 ]
			tmpMatrix.tx = stateStack[ currentStateIndex ].modelViewMatrix.rawData[ 12 ]
			tmpMatrix.ty = stateStack[ currentStateIndex ].modelViewMatrix.rawData[ 13 ]


			var colorTransform : ColorTransform = null
			if( stateStack[ currentStateIndex ].opacity < 1 ) {
				colorTransform = new ColorTransform( 1, 1, 1, stateStack[ currentStateIndex ].opacity )
			}

			colorBuffer.bitmapData.draw(
				texture.privateBitmapDataResource,
				tmpMatrix,
				colorTransform,
				null,
				null,
				true
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
				type: "display-list"
			}
		}
	}
}
