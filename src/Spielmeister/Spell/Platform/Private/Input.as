package Spielmeister.Spell.Platform.Private {

	import Spielmeister.Underscore

	import flash.display.Stage
	import flash.events.KeyboardEvent
	import flash.events.MouseEvent
	import flash.ui.Multitouch
	import flash.ui.MultitouchInputMode


	public class Input {
		private var stage : Stage
		private var eventManager : Object
		private var mouseHandler : Function
		private var keyHandler : Function
		private var nativeEventMap : Object
		private var _ : Underscore
		private var screenWidth : Number
		private var screenHeight : Number


		public function Input( stage : Stage, eventManager : Object, Events : Object ) {
			this.stage = stage
			this.eventManager = eventManager
			this._ = new Underscore()

			this.nativeEventMap = {
				mousedown : {
					eventName : MouseEvent.MOUSE_DOWN,
					handler   : this.nativeMouseHandler
				},
				mouseup : {
					eventName : MouseEvent.MOUSE_UP,
					handler   : this.nativeMouseHandler
				},
				keydown : {
					eventName : KeyboardEvent.KEY_DOWN,
					handler   : this.nativeKeyHandler
				},
				keyup : {
					eventName : KeyboardEvent.KEY_UP,
					handler   : this.nativeKeyHandler
				}
			}

			Multitouch.inputMode = MultitouchInputMode.NONE

			eventManager.subscribe(
				[ Events.SCREEN_RESIZED ],
				_.bind(
					function( width, height ) {
						this.screenWidth  = width
						this.screenHeight = height
					},
					this
				)
			)
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

		private function nativeMouseHandler( callback : Function, event : MouseEvent ) : void {
			callback( {
				type     : event.type.toLowerCase(),
				position : [ event.stageX / this.screenWidth, event.stageY / this.screenHeight ]
			} )
		}

		private function nativeKeyHandler( callback : Function, event : KeyboardEvent ) : void {
			callback( {
				type    : event.type.toLowerCase(),
				keyCode : event.keyCode
			} )
		}

		private function isEventSupported( eventName : String ) : Boolean {
			return _.has( nativeEventMap, eventName )
		}
	}
}
