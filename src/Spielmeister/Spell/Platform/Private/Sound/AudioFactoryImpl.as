package Spielmeister.Spell.Platform.Private.Sound {

	public class AudioFactoryImpl {
		public const BACK_END_FLASH_MEDIA : String = 'flash-media'

		public function AudioFactoryImpl() {
		}

		public function createAudioContext( requestedBackEnd : String = BACK_END_FLASH_MEDIA ) : AudioContext {
			return new AudioContext()
		}
	}
}
