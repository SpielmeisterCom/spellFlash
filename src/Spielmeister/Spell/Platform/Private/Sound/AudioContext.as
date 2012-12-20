package Spielmeister.Spell.Platform.Private.Sound {

	import Spielmeister.Spell.Platform.Private.Sound.FixedSoundChannel

	import flash.media.Sound
	import flash.media.SoundMixer
	import flash.media.SoundTransform


	public class AudioContext {
		private var soundChannels : Object = {}
		private var allMuted : Boolean = false

		public function AudioContext() {
		}

		private function addSoundChannel( id : String, x : FixedSoundChannel ) : void {
			soundChannels[ id ] = x
		}

		private function getSoundChannel( id : String ) : FixedSoundChannel {
			return soundChannels[ id ]
		}

		public function tick() : void {}

		public function play( audioResource : Object, ... rest ) : void {
			var numRest : uint  = rest.length,
				loop : Boolean  = numRest > 2 ? rest[ 2 ] : false,
				volume : Number = numRest > 1 ? rest[ 1 ] : 1,
				id : String     = numRest > 0 ? rest[ 0 ] : undefined

			if( id ) {
				var soundChannel : FixedSoundChannel = getSoundChannel( id )

				if( !soundChannel )  {
					addSoundChannel(
						id,
						new FixedSoundChannel( audioResource.sound, volume, loop ).play()
					)

				} else {
					if( !soundChannel.playing ) {
						soundChannel.play()
					}
				}

			} else {
				audioResource.sound.play()
			}
		}

		public function setLoop( id : String, loop : Boolean ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.loop = loop
		}

		public function setVolume( id : String, volume : Number ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.setVolume( volume )
		}

		public function setAllMuted( muted : Boolean ) : void {
			allMuted = muted

			var soundTransform : SoundTransform = new SoundTransform()
			soundTransform.volume = allMuted ? 0 : 1

			SoundMixer.soundTransform = soundTransform
		}

		public function isAllMuted() : Boolean {
			return allMuted
		}

		public function stop( id : String ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.stop()
		}

		public function mute( id : String ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.muted = true
		}

		public function destroy( id : String ) : void {
			var soundChannel : FixedSoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.stop()

			delete soundChannels[ id ]
		}

		public function createSound( sound : Sound ) : Object {
			return {
				/*
				 * Public
				 */
				duration : sound.length,

				/*
				 * Private
				 *
				 * This is an implementation detail of the class. If you write code that depends on this you better know what you are doing.
				 */
				sound : sound
			}
		}
	}
}
