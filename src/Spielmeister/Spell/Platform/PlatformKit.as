package Spielmeister.Spell.Platform {

	import flash.display.*
	import flash.geom.ColorTransform
	import flash.geom.Matrix

	import Spielmeister.Spell.Platform.Private.Graphics.*


	public class PlatformKit {
		[Embed(source="/home/martin/workspace/spell/SpellJS/images/4.2.04_256.png")]
		private static const embeddedBitmapAsset1 : Class

		private var renderingFactory : RenderingFactoryImpl


		public function PlatformKit( root : DisplayObject ) {
			this.renderingFactory = new RenderingFactoryImpl( root )
		}

		public function createCallNextFrame() : Function {
			trace( "createCallNextFrame" )


			return function() : void {}
		}

		public function updateDebugData() : void {
			trace( "updateDebugData" )
		}

		public function createInputEvents() : void {
			trace( "createInputEvents" )
		}

		public function createSocket( x ) : Object {
			trace( "createSocket" )

			return {
				on: function( x1, x2 ) {
					trace( "register on callback")
				}
			}
		}

		public function get RenderingFactory() : RenderingFactoryImpl {
			trace( "RenderingFactory" )

			return renderingFactory
		}

		public function loadImages( basePath, imagePaths, callback : Function ) : Object {
			log( "loadImages" )


			var bitmapAsset = new embeddedBitmapAsset1()


			log( "height: " + bitmapAsset.bitmapData.height )


			var images = new Object()
			images[ imagePaths[ 0 ] ] = bitmapAsset

			callback( images )


			return images
		}

		public function log( message : String ) : void {
			var now : Date = new Date()

			trace( "[" + now.toDateString() + " " + now.toLocaleTimeString() + " " + now.getFullYear() + "] " +  message )
		}
	}
}
