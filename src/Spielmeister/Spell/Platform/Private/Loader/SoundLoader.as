package Spielmeister.Spell.Platform.Private.Loader {

	import Spielmeister.Spell.Platform.Private.Sound.AudioContext

import flash.debugger.enterDebugger;

import flash.media.Sound


	public class SoundLoader implements Loader {
		private var audioContext : AudioContext
		private var resourcePath : String
		private var resourceName : String
		private var onLoadCallback : Function
		private var onErrorCallback : Function

		public function SoundLoader( audioContext : AudioContext, resourcePath : String, resourceName : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) {
			this.audioContext    = audioContext
			this.resourcePath    = resourcePath
			this.resourceName    = resourceName
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

			this.audioContext.loadBuffer( resourcePath + '/' + this.resourceName, onLoad )
		}
	}
}
