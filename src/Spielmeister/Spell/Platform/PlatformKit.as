package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.Graphics.*
	import Spielmeister.Spell.Platform.Private.Input
	import Spielmeister.Spell.Platform.Private.Loader.*
	import Spielmeister.Spell.Platform.Private.Socket.WebSocketAdapter

	import flash.display.*
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.utils.Timer


	public class PlatformKit {

		private var root : DisplayObject
		private var stage : Stage
		private var origin : String
		private var renderingFactory : RenderingFactoryImpl
		private var registeredNextFrame : Boolean = false


		public function PlatformKit( root : DisplayObject, stage : Stage, origin : String ) {
			this.root = root
			this.stage = stage
			this.origin = origin
			this.renderingFactory = new RenderingFactoryImpl( root )
		}

		public function callNextFrame( callback : Function ) : void {
			if( registeredNextFrame ) return

			root.addEventListener( Event.ENTER_FRAME, callback )
			registeredNextFrame = true
		}

		public function updateDebugData( localTimeInMs : int ) : void {
//			trace( "updateDebugData - not yet implemented" )
		}

		public function createInputEvents() : Object {
			return Input.createInputEvents( stage )
		}

		public function get RenderingFactory() : RenderingFactoryImpl {
			return renderingFactory
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
