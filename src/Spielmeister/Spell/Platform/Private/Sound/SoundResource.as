package Spielmeister.Spell.Platform.Private.Sound {

	import flash.media.Sound

	public class SoundResource {
		public var duration : Number
		public var sound : Sound

		public function SoundResource( sound : Sound ) {
			this.duration = sound.length
			this.sound = sound
		}
	}
}
