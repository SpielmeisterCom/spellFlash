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
		private var _ : Underscore

		public function Input( stage : Stage, configurationManager : Object ) {
			this.stage = stage
			this.configurationManager = configurationManager
			this._ = new Underscore()

			Multitouch.inputMode = MultitouchInputMode.NONE
		}

		public function setInputEventListener( callback : Function ) : void {
			stage.addEventListener(
				MouseEvent.MOUSE_DOWN,
				_.bind( this.nativeMouseClickHandler, null, callback ),
				false
			)

			stage.addEventListener(
				MouseEvent.MOUSE_UP,
				_.bind( this.nativeMouseClickHandler, null, callback ),
				false
			)

			// TODO: Listen to MouseEvent.RIGHT_CLICK

			stage.addEventListener(
				MouseEvent.MOUSE_MOVE,
				_.bind( this.nativeMouseMoveHandler, null, callback ),
				false
			)

			stage.addEventListener(
				MouseEvent.MOUSE_WHEEL,
				_.bind( this.nativeMouseWheelHandler, null, callback ),
				false
			)

			stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				_.bind( this.nativeKeyHandler, null, callback ),
				false
			)

			stage.addEventListener(
				KeyboardEvent.KEY_UP,
				_.bind( this.nativeKeyHandler, null, callback ),
				false
			)
		}

		public function removeInputEventListener() : void {
			trace( 'removeInputEventListener(...) - not yet implemented' )
		}

		private function nativeMouseClickHandler( callback : Function, event : MouseEvent ) : void {
			callback( {
				type      : event.type.toLowerCase() == 'mousedown' ? 'pointerDown' : 'pointerUp',
				pointerId : 1,
				button    : event.buttonDown ? 0 : 1,
				position  : [ event.stageX, event.stageY ]
			} )
		}

		private function nativeMouseMoveHandler( callback : Function, event : MouseEvent ) : void {
			callback( {
				type      : 'pointerMove',
				pointerId : 1,
				button    : -1,
				position  : [ event.stageX, event.stageY ]
			} )
		}

		private function nativeMouseWheelHandler( callback : Function, event : MouseEvent ) : void {
			callback( {
				type : 'mouseWheel',
				direction : event.delta > 0 ? 1 : -1
			} )
		}

		private function nativeKeyHandler( callback : Function, event : KeyboardEvent ) : void {
			callback( {
				type    : ( event.type.toLowerCase() == 'keyup' ) ? 'keyUp' : 'keyDown',
				keyCode : event.keyCode
			} )
		}
	}
}
