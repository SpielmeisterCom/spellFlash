package Spielmeister.Spell.Platform {

	import Spielmeister.Needjs
	import Spielmeister.Spell.Platform.Private.Box2D.createBox2DObject
	import Spielmeister.Spell.Platform.Private.Graphics.*
	import Spielmeister.Spell.Platform.Private.Graphics.DisplayList.DisplayListContext
	import Spielmeister.Spell.Platform.Private.Input
	import Spielmeister.Spell.Platform.Private.Loader.*
	import Spielmeister.Spell.Platform.Private.Network.Http.Request
	import Spielmeister.Spell.Platform.Private.Network.Socket.WebSocketAdapter
	import Spielmeister.Spell.Platform.Private.Sound.AudioContext
	import Spielmeister.Spell.Platform.Private.Sound.AudioFactoryImpl
	import Spielmeister.Spell.Platform.Private.Storage.PersistentStorage

	import com.adobe.serialization.json.JSON

	import flash.display.*
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities
	import flash.system.Security
	import flash.text.TextField
	import flash.text.TextFieldAutoSize
	import flash.utils.getDefinitionByName
	import flash.utils.Timer
	import flash.net.*


	public class PlatformKit {
		[Embed(source="splash.png")]
		private var Splash:Class;

		private var stage : Stage
		private var root : DisplayObject
		private var host : String
		private var loaderUrl : String
		private var needjs : Needjs
		private var anonymizeModuleIds : Boolean
		private var audioFactory : AudioFactoryImpl
		private var renderingFactory : RenderingFactoryImpl
		private var registeredNextFrame : Boolean = false
		private var debugConsole : TextField
		private var debugConsoleContent : String = ""


		public function PlatformKit( stage : Stage, root : DisplayObject, loaderUrl : String, needjs : Needjs, anonymizeModuleIds : Boolean = false ) {
			this.stage              = stage
			this.root               = root
			this.host               = createHost( loaderUrl )
			this.loaderUrl          = loaderUrl
			this.audioFactory       = new AudioFactoryImpl()
			this.renderingFactory   = new RenderingFactoryImpl( stage )
			this.needjs             = needjs
			this.anonymizeModuleIds = anonymizeModuleIds

			// initializing stage
			this.stage.quality   = StageQuality.MEDIUM
			this.stage.scaleMode = StageScaleMode.NO_SCALE
			this.stage.align     = StageAlign.TOP_LEFT
			this.stage.frameRate = 60

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

		public function get AudioFactory() : AudioFactoryImpl {
			return audioFactory
		}

		public function get RenderingFactory() : RenderingFactoryImpl {
			return renderingFactory
		}

		public function get network() : Object {
			return {
				performHttpRequest : Request.perform,
				createSocket : function( host : String ) : Object {
					var serverUrl : String = 'ws://' + host
					var protocol: String = 'socketrocket-0.1'

					return new WebSocketAdapter(
						serverUrl,
						// see https://github.com/Worlize/WebSocket-Node/wiki/Documentation - "origin"
						loaderUrl,
						protocol
					)
				}
			}
		}

		public function registerTimer( callback : Function, timeInMs : uint ) : void {
			var myTimer : Timer = new Timer( timeInMs, 1 )
			myTimer.start()
			myTimer.addEventListener( TimerEvent.TIMER_COMPLETE, callback )
		}

		public function createImageLoader( renderingContext : DisplayListContext, resourcePath : String, resourceName : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) : ImageLoader {
			return new ImageLoader( renderingContext, resourcePath, resourceName, onLoadCallback, onErrorCallback, onTimedOutCallback )
		}

		public function createSoundLoader( audioContext : AudioContext, resourcePath : String, resourceName : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) : SoundLoader {
			return new SoundLoader( audioContext, resourcePath, resourceName, onLoadCallback, onErrorCallback, onTimedOutCallback )
		}

		public function createTextLoader( resourcePath : String, resourceName : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) : TextLoader {
			return new TextLoader( resourcePath, resourceName, onLoadCallback, onErrorCallback, onTimedOutCallback )
		}

		public function getHost() : String {
			return host
		}

		public function get ModuleLoader() : Object {
			return {
				createDependentModules : function() : void {
					throw 'Error: ModuleLoader.createDependentModules is not implemented.'
				},
				define : function( name : String, ... rest ) : void {
                    needjs.createDefine( anonymizeModuleIds )( name, rest[ 0 ], rest[ 1 ] )
				},
				require : function( name : String, ... rest ) : * {
                    return needjs.createRequire()( name, rest[ 0 ], rest[ 1 ] )
				}
			}
		}

		public function get Box2D() : Object {
			return createBox2DObject()
		}

		public function get configurationOptions() : Object {
			var validOptions : Object = {
				audioBackEnd : {
					validValues : [ 'flash-media' ],
					configurable : true
				},
				renderingBackEnd : {
					validValues : [ 'display-list' ],
					configurable : true
				},
				screenMode : {
					configurable : false
				},
				libraryUrl : {
					configurable : true
				}
			}

			var defaultOptions : Object = {
				audioBackEnd : 'flash-media',
				renderingBackEnd : 'display-list',
				screenMode : 'fixed',
				libraryUrl : '../library'
			}

			return {
				defaultOptions : defaultOptions,
				validOptions : validOptions
			}
		}

		public function get jsonCoder() : Object {
			return com.adobe.serialization.json.JSON
		}

		public function createInput( configurationManager : Object, renderingContext : Object ) : Input {
			return new Input( stage, configurationManager )
		}

		public function get platformDetails() : Object {
			return {
				hasPlentyRAM : function() : Boolean {
					return true
				},
				hasTouchSupport : function() : Boolean {
					return false
				},
				getOS : function() : String {
					return Capabilities.os
				},
				getPlatformAdapter : function() : String {
					return 'flash'
				},
				getPlatform : function() : String {
					return Capabilities.version
				},
				getDevice : function() : String {
					return 'unknown'
				},
				getScreenHeight : function() : Number {
					return Capabilities.screenResolutionY
				},
				getScreenWidth : function() : Number {
					return Capabilities.screenResolutionX
				},
				isMobileDevice : function() : Boolean {
					return false
				}
			}
		}

		public function registerOnScreenResize( eventManager : Object, id : String, initialScreenSize : Array ) : void {
			var events = this.needjs.getModuleInstanceById(
				'spell/Events',
				this.anonymizeModuleIds
			)

			eventManager.publish(
				events.AVAILABLE_SCREEN_SIZE_CHANGED,
				[ initialScreenSize ]
			)

			this.stage.addEventListener(
				Event.RESIZE,
				function( event : Event ) : void {
					eventManager.publish(
						events.AVAILABLE_SCREEN_SIZE_CHANGED,
						[ [ event.target.stageWidth, event.target.stageHeight ] ]
					)
				}
			)
		}

		public function openURL( url : String, message : String ) : void {
			navigateToURL( new URLRequest( url ) , '_blank' )
		}

		public function createPersistentStorage() : Object {
			return new PersistentStorage()
		}

		private function createHost( loaderUrl : String ) : String {
			var pattern : RegExp = /^(?:http:\/\/)?([^\/]+)/
			var matches : Array = loaderUrl.match( pattern )

			return matches[ 1 ]
		}

		public function loadInterstitial() : void {}
		public function showInterstitial() : void {}

		public function get flurry() : Object {
			return {
				logEvent : function( eventName : String, timed : Boolean ) : void {},
				endTimedEvent : function() : void {}
			}
		}

		public function createComponentType( moduleLoader : Object, spell : Object, componentId : String ) : * {
			var className : String = 'Spielmeister.ComponentType.'

			for( var i = 0, n = componentId.length, charCode; i < n; i++ ) {
				charCode = componentId.charCodeAt( i )

				className += String.fromCharCode( charCode > 47 && charCode < 58 ? charCode + 17 : charCode )
			}

			if( !ApplicationDomain.currentDomain.hasDefinition( className ) ) {
				return
			}

			var classReference : Class = getDefinitionByName( className ) as Class

			return new classReference( spell )
		}

		public function getAvailableScreenSize( id : String ) : Array {
			// This is not trivial to implement properly. For compatibility this method returns an array with bogus values.
			return [ 0, 0 ]
		}

		public function get Application() : Object {
			return {
				close : function() : void {}
			}
		}

		public function createSplashScreenImage() : BitmapData {
			var splashImage : Bitmap = new Splash()

			return splashImage.bitmapData
		}
	}
}
