package Spielmeister.Spell.Platform.Private.Sound {

	import Spielmeister.Spell.Platform.Private.Sound.FixedSoundChannel

	import flash.media.Sound
	import flash.media.SoundMixer
	import flash.media.SoundTransform
	import flash.events.Event
	import flash.net.URLRequest


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

			SoundMixer.soundTransform = new SoundTransform( allMuted ? 0 : 1 )
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

			// HACK: In order to comply with the reference implementation mute is implemented as an alias to "setVolume(0)".
//			soundChannel.muted = true
			soundChannel.setVolume( 0 )
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

		public function loadBuffer( src : String, onLoadCallback : Function ) : void {
			var srcParts : Array = src.split( '.' )

			srcParts.pop()

			var sound : Sound = new Sound(),
				url : String  = srcParts.join( '/' ) + '.mp3'

			sound.addEventListener(
				Event.COMPLETE,
				function( event : Event ) : void {
					onLoadCallback( event.target as Sound )
				}
			)

			sound.load( new URLRequest( url ) )
		}

		public function getConfiguration() : Object {
			return { type : 'flash' }
		}
	}
}
