package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.Graphics.*
	import Spielmeister.Spell.Platform.Private.Loader.*
	import Spielmeister.Spell.Platform.Private.Socket.WebSocketAdapter

	import flash.display.*
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.utils.Timer


	public class PlatformKit {
		[Embed(source="/home/martin/workspace/spell/SpellJS/images/4.2.04_256.png")]
		private static const embeddedBitmapAsset1 : Class

		private var root : DisplayObject
		private var origin : String
		private var renderingFactory : RenderingFactoryImpl


		public function PlatformKit( root : DisplayObject, origin : String ) {
			this.root = root
			this.origin = origin
			this.renderingFactory = new RenderingFactoryImpl( root )
		}

		public function callNextFrame( callback : Function ) : void {
//			trace( "callNextFrame - not yet implemented" )

			// TODO: only register for this event once, not every main loop iteration
			root.addEventListener( Event.ENTER_FRAME, callback )
		}

		public function updateDebugData( localTimeInMs : int ) : void {
			trace( "updateDebugData - not yet implemented" )
		}

		public function createInputEvents() : Object {
			trace( "createInputEvents - not yet implemented" )

			return new Array()
		}

		public function get RenderingFactory() : RenderingFactoryImpl {
			return renderingFactory
		}

		// TODO: remove this because its deprecated
		public function loadImages( basePath, imagePaths, callback : Function ) : Object {
			var bitmapAsset = new embeddedBitmapAsset1()


			var images = new Object()
			images[ imagePaths[ 0 ] ] = bitmapAsset.bitmapData

			callback( images )


			return images
		}

		public function log( message : String ) : void {
			var now : Date = new Date()

			trace( "[" + now.toDateString() + " " + now.toLocaleTimeString() + " " + now.getFullYear() + "] " +  message )
		}

		public function createSocket() : Object {
			var url : String = 'ws://localhost:8080/'
			var protocol: String = 'socketrocket-0.1'

			return new WebSocketAdapter(
				url,
				// see https://github.com/Worlize/WebSocket-Node/wiki/Documentation - "origin"
				origin,
				protocol
			)
		}

		public function registerTimer( callback : Function, timeInMs : uint ) : void {
			var myTimer : Timer = new Timer( timeInMs, 1 )
			myTimer.start()
			myTimer.addEventListener( TimerEvent.TIMER_COMPLETE, callback )
		}

		public function createImageLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) : ImageLoader {
			return new ImageLoader( eventManager, resourceBundleName, resourceUri, callback )
		}

		public function createSoundLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) : SoundLoader {
			return new SoundLoader( eventManager, resourceBundleName, resourceUri, callback )
		}

		public function createTextLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) : TextLoader {
			return new TextLoader( eventManager, resourceBundleName, resourceUri, callback )
		}
	}
}
