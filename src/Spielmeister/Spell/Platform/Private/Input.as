package Spielmeister.Spell.Platform.Private {

	import Spielmeister.Underscore

	import flash.display.Stage
	import flash.events.KeyboardEvent
	import flash.events.MouseEvent
	import flash.ui.Multitouch
	import flash.ui.MultitouchInputMode

	public class Input {
		private var stage : Stage
		private var configurationManager : Object
		private var nativeEventMap : Object
		private var _ : Underscore


		public function Input( stage : Stage, configurationManager : Object ) {
			this.stage = stage
			this.configurationManager = configurationManager
			this._ = new Underscore()

			this.nativeEventMap = {
				mousedown : {
					eventName : MouseEvent.MOUSE_DOWN,
					handler : this.nativeMouseClickHandler
				},
				mouseup : {
					eventName : MouseEvent.MOUSE_UP,
					handler : this.nativeMouseClickHandler
				},
				mousemove : {
					eventName : MouseEvent.MOUSE_MOVE,
					handler : this.nativeMouseMoveHandler
				},
				mousewheel : {
					eventName : MouseEvent.MOUSE_WHEEL,
					handler : this.nativeMouseWheelHandler
				},
				keydown : {
					eventName : KeyboardEvent.KEY_DOWN,
					handler : this.nativeKeyHandler
				},
				keyup : {
					eventName : KeyboardEvent.KEY_UP,
					handler : this.nativeKeyHandler
				}
			}

			Multitouch.inputMode = MultitouchInputMode.NONE
		}

		public function setInputEventListener( eventName : String, callback : Function ) : void {
			if( !isEventSupported( eventName ) ) return

			var nativeEvent : Object = nativeEventMap[ eventName ]

			stage.addEventListener(
				nativeEvent.eventName,
				_.bind( nativeEvent.handler, null, callback ),
				false
			)
		}

		public function removeInputEventListener( eventName : String ) : void {
			if( !isEventSupported( eventName ) ) return

			trace( 'removeInputEventListener(...) - not yet implemented' )
		}

		private function nativeMouseClickHandler( callback : Function, event : MouseEvent ) : void {
			var screenSize : Object = this.configurationManager.screenSize

			callback( {
				type : event.type.toLowerCase(),
				position : [ event.stageX / screenSize[ 0 ], event.stageY / screenSize[ 1 ] ]
			} )
		}

		private function nativeMouseMoveHandler( callback : Function, event : MouseEvent ) : void {
			var screenSize : Object = this.configurationManager.screenSize

			callback( {
				type : event.type.toLowerCase(),
				position : [ event.stageX / screenSize[ 0 ], event.stageY / screenSize[ 1 ] ]
			} )
		}

		private function nativeMouseWheelHandler( callback : Function, event : MouseEvent ) : void {
			callback( {
				type : event.type.toLowerCase(),
				direction : event.delta > 0 ? 1 : -1
			} )
		}

		private function nativeKeyHandler( callback : Function, event : KeyboardEvent ) : void {
			callback( {
				type : event.type.toLowerCase(),
				keyCode : event.keyCode
			} )
		}

		private function isEventSupported( eventName : String ) : Boolean {
			return _.has( nativeEventMap, eventName )
		}
	}
}
