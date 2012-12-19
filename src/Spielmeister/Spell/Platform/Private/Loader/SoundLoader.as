package Spielmeister.Spell.Platform.Private.Loader {

import flash.debugger.enterDebugger;
import flash.events.Event
	import flash.media.Sound
	import flash.net.URLRequest


	public class SoundLoader implements Loader {
		private var resourcePath : String
		private var resourceName : String
		private var onLoadCallback : Function
		private var onErrorCallback : Function

		public function SoundLoader( resourcePath : String, resourceName : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) {
			this.resourcePath    = resourcePath
			this.resourceName    = resourceName
			this.onLoadCallback  = onLoadCallback
			this.onErrorCallback = onErrorCallback
		}

		public function start() : void {
			var resourceParts : Array = resourceName.split( '.' )
				resourceParts.pop()

			var sound : Sound = new Sound(),
				url : String  = resourcePath + '/' + resourceParts.join( '/' ) + '.mp3'

			sound.addEventListener( Event.COMPLETE, onLoad )
			sound.load( new URLRequest( url ) )
		}

		private function onLoad( event : Event ) : void {
			this.onLoadCallback( event.target as Sound )
		}
	}
}
