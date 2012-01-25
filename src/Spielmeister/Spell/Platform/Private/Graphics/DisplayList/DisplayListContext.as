package Spielmeister.Spell.Platform.Private.Graphics.DisplayList {

	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.DisplayObject
	import flash.display.Shape
	import flash.display.Sprite
	import flash.geom.ColorTransform
	import flash.geom.Matrix
	import mx.core.BitmapAsset


	public class DisplayListContext {
		private var root : Sprite
		private var colorBuffer : Bitmap


		public function DisplayListContext( root : DisplayObject ) {
			this.root = Sprite( root )

			// setting up the color buffer
			this.colorBuffer = new Bitmap()
			this.colorBuffer.bitmapData = new BitmapData( 320, 240, false, 0x000000)

			this.root.addChild( colorBuffer )
		}

		public function setFillStyleColor( x ) : void {
			trace( "setFillStyleColor - not yet implemented" )
		}

		public function setGlobalAlpha( x ) : void {
			trace( "setGlobalAlpha - not yet implemented" )
		}

		public function setClearColor( x ) : void {
			trace( "setClearColor - not yet implemented" )
		}

		public function save() : void {
			trace( "save - not yet implemented" )
		}

		public function restore() : void {
			trace( "restore - not yet implemented" )
		}

		public function scale( x : Number ) : void {
			trace( "scale - not yet implemented" )
		}

		public function translate( x : Number ) : void {
			trace( "translate - not yet implemented" )
		}

		public function rotate( x : Number ) : void {
			trace( "rotate - not yet implemented" )
		}

		public function clear() : void {
			trace( "clear - not yet implemented" )
		}

		public function drawTexture( texture : Object, x : Number, y : Number ) : void {
			var transformation : Matrix = new Matrix()
			transformation.translate( x, y )

			this.colorBuffer.bitmapData.draw(
				texture.privateBitmapDateResource,
				transformation,
				new ColorTransform( 1, 1, 1, 1 ),
				null,
				null,
				true
			)
		}

		public function createTexture( bitmapAsset : BitmapAsset ) : Object {
			return {
				/**
				 * public
				 */
				width  : bitmapAsset.width,
				height : bitmapAsset.height,

				/**
				 * private
				 *
				 * This is an implementation detail of the class. If you write code that depends on this you better know what you are doing.
				 */
				privateBitmapDateResource: bitmapAsset.bitmapData
			}
		}

		public function getConfiguration() : Object {
			return {
				type: "display-list"
			}
		}
	}
}
