package Spielmeister.Spell.Platform.Private.Sound {

	public class AudioFactoryImpl {
		public function AudioFactoryImpl() {
		}

		public function createAudioContext( requestedBackEnd : uint = 0 ) : AudioContext {
			return new AudioContext()
		}
	}
}
