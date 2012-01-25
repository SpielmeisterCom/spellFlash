package Spielmeister.Spell.Platform.Private.Graphics.DisplayList {

	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.DisplayObject
	import flash.display.Shape
	import flash.display.Sprite
	import flash.geom.ColorTransform
	import flash.geom.Matrix


	public class DisplayListContext {
		private var root : Sprite


		public function DisplayListContext( root : DisplayObject ) {
			this.root = Sprite( root )


			// HACK: testing the rendering
			var colorBuffer : Bitmap = new Bitmap()
			colorBuffer.bitmapData = new BitmapData( 320, 240, false, 0x000000)

			var rectangle : Shape = new Shape; // initializing the variable named rectangle
			rectangle.graphics.beginFill( 0xFF0000 ); // choosing the colour for the fill, here it is red
			rectangle.graphics.drawRect( 0, 0, 50, 50 ); // (x spacing, y spacing, width, height)
			rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill

			var transformation : Matrix = new Matrix()
			transformation.rotate( Math.PI / 4 )

			colorBuffer.bitmapData.draw(
				rectangle,
				transformation,
				new ColorTransform( 1, 1, 1, 1 ),
				null,
				null,
				true
			)

			this.root.addChild( colorBuffer )
		}

		public function setFillStyleColor( x ) {
			trace( "setFillStyleColor - not yet implemented" )
		}

		public function setGlobalAlpha( x ) {
			trace( "setGlobalAlpha - not yet implemented" )
		}

		public function setClearColor( x ) {
			trace( "setClearColor - not yet implemented" )
		}

		public function save() {
			trace( "save - not yet implemented" )
		}

		public function restore() {
			trace( "restore - not yet implemented" )
		}

		public function scale( x ) {
			trace( "scale - not yet implemented" )
		}

		public function translate( x ) {
			trace( "translate - not yet implemented" )
		}

		public function rotate( x ) {
			trace( "rotate - not yet implemented" )
		}

		public function clear() {
			trace( "clear - not yet implemented" )
		}

		public function drawTexture( x, y, z ) {
			trace( "drawTexture - not yet implemented" )
		}

		public function createTexture( x ) {
			trace( "createTexture - not yet implemented" )

			return {
				width  : 0,
				height : 0
			}
		}

		public function getConfiguration() {
			trace( "getConfiguration - not yet implemented" )
		}
	}
}
