package Spielmeister.Spell.Platform.Private.Loader {

	import Spielmeister.Spell.Platform.Private.Sound.AudioContext

import flash.debugger.enterDebugger;

import flash.media.Sound


	public class SoundLoader implements Loader {
		private var audioContext : AudioContext
		private var libraryUrl : String
		private var libraryPath : String
		private var onLoadCallback : Function
		private var onErrorCallback : Function

		public function SoundLoader( audioContext : AudioContext, libraryUrl : String, libraryPath : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) {
			this.audioContext    = audioContext
			this.libraryUrl    = libraryUrl
			this.libraryPath    = libraryPath
			this.onLoadCallback  = onLoadCallback
			this.onErrorCallback = onErrorCallback
		}

		public function start() : void {
			var audioContext : AudioContext = this.audioContext,
				onLoadCallback : Function   = this.onLoadCallback

			var onLoad : Function = function( sound : Sound ) : void {
				onLoadCallback(
					audioContext.createSound( sound )
				)
			}

			var url : String = libraryUrl ? libraryUrl + '/' + libraryPath : libraryPath

			this.audioContext.loadBuffer( url, onLoad )
		}
	}
}
