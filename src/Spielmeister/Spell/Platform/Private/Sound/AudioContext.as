package Spielmeister.Spell.Platform.Private.Sound {

	import flash.media.Sound
	import flash.media.SoundChannel
	import flash.media.SoundMixer

	import flash.debugger.enterDebugger


	public class AudioContext {
		private var soundId : uint = 1
		private var soundChannels : Object = {}
		private var allMuted : Boolean = false

		public function AudioContext() {
		}

		private function createSoundId() : String {
			return ( soundId++ ).toString()
		}

		private function addSoundChannel( id : String, x : SoundChannel ) : void {
			soundChannels[ id ] = x
		}

		private function getSoundChannel( id : String ) : SoundChannel {
			return soundChannels[ id ]
		}


		public function tick() : void {}

		public function play( audioResource : Object, ... rest ) : void {
			var numRest = rest.length

			var loop : Boolean  = numRest > 2 ? rest[ 2 ] : false,
				volume : Number = numRest > 1 ? rest[ 1 ] : 1,
				id : String     = numRest > 0 ? rest[ 0 ] : undefined

			if( id ) {
				trace( 'play: ' + id )

				var soundChannel : SoundChannel = getSoundChannel( id )

				if( !soundChannel )  {
					addSoundChannel( id, audioResource.sound.play() )

				} else {
//					if( !isPlaying( soundChannel ) ) {
//						// TODO: start from beginning
//					}
				}

			} else {
				audioResource.sound.play()
			}
		}

		public function setLoop( id : String, loop : Boolean ) : void {
			trace( 'setLoop: ' + id + ', ' + loop )
		}

		public function setVolume( id : String, volume : Number ) : void {
			trace( 'setVolume: ' + id + ', ' + volume )

			var soundChannel : SoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.soundTransform.volume = volume
		}

		public function setAllMuted( muted : Boolean ) : void {
			trace( 'setAllMuted: ' + muted )

			allMuted = muted

			SoundMixer.soundTransform.volume = allMuted ? 0 : 1
		}

		public function isAllMuted() : Boolean {
			trace( 'isAllMuted' )

			return allMuted
		}

		public function stop( id : String ) : void {
			trace( 'stop: ' + id )

			var soundChannel : SoundChannel = getSoundChannel( id )
			if( !soundChannel ) return

			soundChannel.stop()
		}

		public function mute( id : String ) : void {
			trace( 'mute: ' + id )
		}

		public function destroy( id : String ) : void {
			trace( 'destroy: ' + id )
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
