package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.Graphics.*
	import Spielmeister.Spell.Platform.Private.Input
	import Spielmeister.Spell.Platform.Private.Loader.*
	import Spielmeister.Spell.Platform.Private.Lobby
	import Spielmeister.Spell.Platform.Private.Socket.WebSocketAdapter

	import flash.display.*
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.system.Security
	import flash.utils.Timer
	import mx.core.IChildList


	public class PlatformKit {
		/**
		 * The hostname and port of the game server used when run in deployment mode.
		 */
		private static var serverHostPortDeployment : String = 'guybrush.hq.hauptmedia.de:8080'

		/**
		 * The hostname and port of the game server used when run in development mode.
		 */
		private static var serverHostPortDevelopment : String = 'localhost:8080'

		private var container : IChildList
		private var stage : Stage
		private var root : DisplayObject
		private var origin : String
		private var renderingFactory : RenderingFactoryImpl
		private var registeredNextFrame : Boolean = false


		public function PlatformKit( stage : Stage, root : DisplayObject, container : IChildList, origin : String ) {
			this.stage            = stage
			this.root             = root
			this.container        = container
			this.origin           = origin
			this.renderingFactory = new RenderingFactoryImpl( container )
		}

		public function init() : void {
			Security.allowDomain( '*' )
			Security.loadPolicyFile( 'xmlsocket://' + getServerHostPort() )
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
			var serverUrl : String = 'ws://' + getServerHostPort()
			var protocol: String = 'socketrocket-0.1'

			return new WebSocketAdapter(
				serverUrl,
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
			return new ImageLoader(
				getServerHostPort(),
				eventManager,
				resourceBundleName,
				resourceUri,
				callback
			)
		}

		public function createSoundLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) : SoundLoader {
			return new SoundLoader(
				getServerHostPort(),
				eventManager,
				resourceBundleName,
				resourceUri,
				callback
			)
		}

		public function createTextLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) : TextLoader {
			return new TextLoader(
				getServerHostPort(),
				eventManager,
				resourceBundleName,
				resourceUri,
				callback
			)
		}

		public function createLobby( eventManager : Object, connection : Object ) : Lobby {
			return new Lobby( root, eventManager, connection )
		}

		private function getServerHostPort() : String {
			var regexp : RegExp = /^file:\/\/\//
			return ( regexp.test( this.origin ) ? serverHostPortDevelopment : serverHostPortDeployment )
		}
	}
}
