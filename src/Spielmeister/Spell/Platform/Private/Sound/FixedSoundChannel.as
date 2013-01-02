package Spielmeister.Spell.Platform.Private.Sound {

	import flash.events.Event
	import flash.media.Sound
	import flash.media.SoundChannel
	import flash.media.SoundTransform


	public class FixedSoundChannel {
		private var isPlaying : Boolean = false
		private var isLooped : Boolean = false
		private var isMuted : Boolean = false
		private var sound : Sound
		private var wrappedSoundChannel : SoundChannel
		private var volume : Number = 1

		public function FixedSoundChannel( sound : Sound, volume : Number, isLooped : Boolean ) {
			this.sound  = sound
			this.volume = volume
			this.loop   = isLooped
		}

		public function get playing() : Boolean {
			return isPlaying
		}

		public function set loop( v : Boolean ) : void {
			isLooped = v
		}

		public function get loop() : Boolean {
			return isLooped
		}

		public function set muted( v : Boolean ) : void {
			isMuted = v

			if( wrappedSoundChannel ) {
				wrappedSoundChannel.soundTransform = new SoundTransform( isMuted ? 0 : volume )
			}
		}

		public function get muted() : Boolean {
			return isMuted
		}

		public function play() : FixedSoundChannel {
			isPlaying = true

			wrappedSoundChannel = sound.play()

			if( wrappedSoundChannel ) {
				wrappedSoundChannel.addEventListener( Event.SOUND_COMPLETE, onComplete )
			}

			muted = isMuted

			return this
		}

		public function stop() : void {
			if( wrappedSoundChannel ) {
				wrappedSoundChannel.stop()
			}

			isPlaying = false
		}

		public function setVolume( v : Number ) : void {
			volume = v

			if( wrappedSoundChannel ) {
				wrappedSoundChannel.soundTransform = new SoundTransform( isMuted ? 0 : volume )
			}
		}

		private function onComplete( event : Event ) : void {
			event.currentTarget.removeEventListener( Event.SOUND_COMPLETE, onComplete )

			if( isLooped ) {
				play()

			} else {
				isPlaying = false
			}
		}
	}
}
