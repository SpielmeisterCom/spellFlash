package Spielmeister.Spell.Platform.Private.Sound {

	public class AudioContext {
		public function AudioContext() {
		}

		public function tick() : void {}

		public function play( audioResource : Object, ... rest ) : void {
			// rest : [ id : String, volume : Number, loop : Boolean ]
		}

		public function setLoop( id : String, loop : Boolean ) : void {}

		public function setVolume( id : String, volume : Number ) : void {}

		public function setAllMuted( muted : Boolean ) : void {}

		public function isAllMuted() : Boolean { return true }

		public function stop( id : String ) : void {}

		public function mute( id : String ) : void {}

		public function destroy( id : String ) : void {}

		public function createSound( audioBuffer : Object ) : Object {
			return {
				/*
				 * Public
				 */
				duration : 0,

				/*
				 * Private
				 *
				 * This is an implementation detail of the class. If you write code that depends on this you better know what you are doing.
				 */
				privateAudioResource : undefined
			}
		}
	}
}
