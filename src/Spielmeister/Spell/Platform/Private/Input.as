package Spielmeister.Spell.Platform.Private {

	import flash.display.Stage
	import flash.events.KeyboardEvent


	public class Input {

		public static function createInputEvents( stage : Stage ) : Array {
			var nextSequenceNumber : int = 0
			var inputEvents : Array = new Array()

			var keyHandler : Function = function( event : KeyboardEvent ) : void {
				inputEvents.push( {
					type           : event.type.toLowerCase(),
					keyCode        : event.keyCode,
					sequenceNumber : nextSequenceNumber
				} )

				nextSequenceNumber += 1
			}

			stage.addEventListener(
				KeyboardEvent.KEY_DOWN,
				keyHandler,
				false
			)

			stage.addEventListener(
				KeyboardEvent.KEY_UP,
				keyHandler,
				false
			)

			return inputEvents
		}
	}
}
