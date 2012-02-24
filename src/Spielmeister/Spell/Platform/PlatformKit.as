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
		private var container : IChildList
		private var stage : Stage
		private var root : DisplayObject
		private var host : String
		private var loaderUrl : String
		private var urlParameters : Object
		private var renderingFactory : RenderingFactoryImpl
		private var registeredNextFrame : Boolean = false


		public function PlatformKit( stage : Stage, root : DisplayObject, container : IChildList, loaderUrl : String, urlParameters : Object ) {
			this.stage            = stage
			this.root             = root
			this.container        = container
			this.host             = createHost( loaderUrl )
			this.loaderUrl        = loaderUrl
			this.urlParameters    = urlParameters
			this.renderingFactory = new RenderingFactoryImpl( container )

			this.stage.quality = StageQuality.MEDIUM
		}

		public function init() : void {
			Security.allowDomain( '*' )
			Security.loadPolicyFile( 'xmlsocket://' + host )
		}

		public function callNextFrame( callback : Function ) : void {
			if( registeredNextFrame ) return

			root.addEventListener( Event.ENTER_FRAME, callback )
			registeredNextFrame = true
		}

		public function updateDebugData( localTimeInMs : int ) : void {
//			trace( "updateDebugData - not yet implemented" )
		}

		public function createInputEvents( screenSizeConfig : Object ) : Object {
			return Input.createInputEvents( stage )
		}

		public function get RenderingFactory() : RenderingFactoryImpl {
			return renderingFactory
		}

		public function log( message : String ) : void {
			var now : Date = new Date()

			trace( "[" + now.toDateString() + " " + now.toLocaleTimeString() + "] " +  message )
		}

		public function createSocket( host : String ) : Object {
			var serverUrl : String = 'ws://' + host
			var protocol: String = 'socketrocket-0.1'

			return new WebSocketAdapter(
				serverUrl,
				// see https://github.com/Worlize/WebSocket-Node/wiki/Documentation - "origin"
				loaderUrl,
				protocol
			)
		}

		public function registerTimer( callback : Function, timeInMs : uint ) : void {
			var myTimer : Timer = new Timer( timeInMs, 1 )
			myTimer.start()
			myTimer.addEventListener( TimerEvent.TIMER_COMPLETE, callback )
		}

		public function createImageLoader( eventManager : Object, host : String, resourceBundleName : String, resourceUri : String, callback : Function ) : ImageLoader {
			return new ImageLoader(
				eventManager,
				host,
				resourceBundleName,
				resourceUri,
				callback
			)
		}

		public function createSoundLoader( eventManager : Object, host : String, resourceBundleName : String, resourceUri : String, callback : Function ) : SoundLoader {
			return new SoundLoader(
				eventManager,
				host,
				resourceBundleName,
				resourceUri,
				callback
			)
		}

		public function createTextLoader( eventManager : Object, host : String, resourceBundleName : String, resourceUri : String, callback : Function ) : TextLoader {
			return new TextLoader(
				eventManager,
				host,
				resourceBundleName,
				resourceUri,
				callback
			)
		}

		public function createLobby( eventManager : Object, connection : Object ) : Lobby {
			return new Lobby( root, eventManager, connection, stage.width, stage.height )
		}

		public function getHost() : String {
			return host
		}

		public function getUrlParameters() : Object {
			return urlParameters
		}

		public function get configurationOptions() : Object {
			var extractRenderingBackEnd : Function = function( validValues : Object, value : String ) : Object {
				return ( value === 'display-list' ? RenderingFactory.BACK_END_DISPLAY_LIST : false )
			}

			var validOptions : Object = {
				renderingBackEnd : {
					validValues : [ 'display-list' ],
					extractor   : extractRenderingBackEnd
				}
			}

			var defaultOptions : Object = {
				renderingBackEnd : 'display-list'
			}

			return {
				defaultOptions : defaultOptions,
				validOptions   : validOptions
			}
		}

		public function getPlatformInfo() : String {
			return 'flash'
		}

		private function createHost( loaderUrl : String ) : String {
			var pattern : RegExp = /^(?:http:\/\/)?([^\/]+)/
			var matches : Array = loaderUrl.match( pattern )

			return matches[ 1 ]
		}
	}
}
