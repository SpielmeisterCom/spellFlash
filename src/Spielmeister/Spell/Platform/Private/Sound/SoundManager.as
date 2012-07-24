package Spielmeister.Spell.Platform.Private.Sound {

	public class SoundManager {
		private var muted : Boolean

		public function isMuted() : Boolean {
			return muted
		}

		public function setMuted( value : Boolean ) : void {
			muted = value
		}
	}
}
