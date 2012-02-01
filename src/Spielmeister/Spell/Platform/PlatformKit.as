package Spielmeister.Spell.Platform {

	import flash.display.*

	import Spielmeister.Spell.Platform.Private.Socket.FlashSocketAdapter
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

		public function createSocket( path, ...arguments ) : Object {
			trace( "createSocket" )

			var config = null
			if( arguments[ 0 ] !== undefined ) {
				config = arguments[ 0 ]
			}


//			FlashSocket.prototype.on = function( messageName, callback ) {
//				this.addEventListener( messageName, callback )
//			}
//
//			FlashSocket.prototype.__defineGetter__(
//				'json',
//				function() : FlashSocket {
////					this.flags.json = true
//					return this
//				}
//			)

			var socket : FlashSocketAdapter = new FlashSocketAdapter( "/pathService" )

//			socket.addEventListener(
//				FlashSocketEvent.CONNECT,
//				function( event : FlashSocketEvent ) : void {
//					trace( event )
//				}
//			)


//			return {
//				on: function( x1, x2 ) {
//					trace( "register on callback")
//				}
//			}

			return socket
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
