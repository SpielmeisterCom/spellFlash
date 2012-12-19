package Spielmeister.Spell.Platform.Private.Sound {

import flash.debugger.enterDebugger;
import flash.events.Event
	import flash.media.Sound
	import flash.media.SoundChannel
import flash.media.SoundTransform;


public class FixedSoundChannel {
		public var isPlaying : Boolean = false
		public var looped : Boolean = false
		public var muted : Boolean = false

		private var sound : Sound
		private var wrappedSoundChannel : SoundChannel
		private var volume : Number = 1

		public function FixedSoundChannel( sound : Sound, looped : Boolean ) {
			this.sound  = sound
			this.looped = looped
		}

		public function play() : FixedSoundChannel {
			isPlaying = true

			wrappedSoundChannel = sound.play()
			wrappedSoundChannel.addEventListener( Event.SOUND_COMPLETE, onComplete )

			setMuted( muted )

			return this
		}

		public function stop() : void {
			wrappedSoundChannel.stop()

			isPlaying = false
		}

		public function setMuted( muted : Boolean ) : void {
			this.muted = muted

			var soundTransform : SoundTransform = new SoundTransform()
			soundTransform.volume = muted ? 0 : volume

			wrappedSoundChannel.soundTransform = soundTransform
		}

		private function onComplete( event : Event ) : void {
			event.currentTarget.removeEventListener( Event.SOUND_COMPLETE, onComplete )

			if( looped ) {
				play()

			} else {
				isPlaying = false
			}
		}
	}
}
