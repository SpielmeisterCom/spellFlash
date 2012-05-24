package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.Graphics.*
	import Spielmeister.Spell.Platform.Private.Input
	import Spielmeister.Spell.Platform.Private.Loader.*
	import Spielmeister.Spell.Platform.Private.Socket.WebSocketAdapter
	import Spielmeister.Spell.Platform.Private.Sound.SoundManager

	import com.adobe.serialization.json.JSON

	import flash.display.*
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.system.Capabilities
	import flash.system.Security
	import flash.system.TouchscreenType
	import flash.text.TextField
	import flash.text.TextFieldAutoSize
	import flash.utils.Timer


	public class PlatformKit {
		private var stage : Stage
		private var root : DisplayObject
		private var host : String
		private var loaderUrl : String
		private var renderingFactory : RenderingFactoryImpl
		private var registeredNextFrame : Boolean = false
		private var debugConsole : TextField
		private var debugConsoleContent : String = ""


		public function PlatformKit( stage : Stage, root : DisplayObject, loaderUrl : String ) {
			this.stage            = stage
			this.root             = root
			this.host             = createHost( loaderUrl )
			this.loaderUrl        = loaderUrl
			this.renderingFactory = new RenderingFactoryImpl( stage )

			// initializing stage
			this.stage.quality   = StageQuality.MEDIUM
			this.stage.scaleMode = StageScaleMode.NO_SCALE
			this.stage.align     = StageAlign.TOP_LEFT
			this.stage.frameRate = 30

			// debug "console"
			this.debugConsole = new TextField()
			this.debugConsole.autoSize = TextFieldAutoSize.LEFT
			this.stage.addChild( debugConsole )
		}

		private function logDebug( message: String ) : void {
			debugConsoleContent += ( !debugConsoleContent ? "" : "\n" ) + message
			debugConsole.text = debugConsoleContent
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

		public function get RenderingFactory() : RenderingFactoryImpl {
			return renderingFactory
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

		public function createImageLoader(
			eventManager : Object,
			host : String,
			resourceBundleName : String,
			resourceUri : String,
			loadingCompletedCallback : Function,
			timedOutCallback : Function,
			... arguments
		) : ImageLoader {
			return new ImageLoader(
				eventManager,
				host,
				resourceBundleName,
				resourceUri,
				loadingCompletedCallback
			)
		}

		public function createSoundLoader(
			eventManager : Object,
			host : String,
			resourceBundleName : String,
			resourceUri : String,
			loadingCompletedCallback : Function,
			timedOutCallback : Function,
			soundManager : Object
		) : SoundLoader {
			return new SoundLoader(
				eventManager,
				host,
				resourceBundleName,
				resourceUri,
				loadingCompletedCallback,
				soundManager
			)
		}

		public function createTextLoader(
			eventManager : Object,
			host : String,
			resourceBundleName : String,
			resourceUri : String,
			loadingCompletedCallback : Function,
			timedOutCallback : Function,
			... arguments
		) : TextLoader {
			return new TextLoader(
				eventManager,
				host,
				resourceBundleName,
				resourceUri,
				loadingCompletedCallback
			)
		}

		public function getHost() : String {
			return host
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

		public function getJsonCoder() : Object {
			return JSON
		}

		public function createInput( configurationManager : Object ) : Input {
			return new Input( stage, configurationManager )
		}

		public function get features() : Object {
			return {
				touch : ( Capabilities.touchscreenType != TouchscreenType.NONE )
			}
		}

		public function registerOnScreenResize( callback : Function ) : void {
			this.stage.addEventListener(
				Event.RESIZE,
				function( event : Event ) : void {
					callback( event.target.stageWidth, event.target.stageHeight )
				}
			)
		}

		public function createSoundManager() : SoundManager {
			return new SoundManager()
		}

		private function createHost( loaderUrl : String ) : String {
			var pattern : RegExp = /^(?:http:\/\/)?([^\/]+)/
			var matches : Array = loaderUrl.match( pattern )

			return matches[ 1 ]
		}
	}
}
