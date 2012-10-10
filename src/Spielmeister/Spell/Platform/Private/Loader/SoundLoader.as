package Spielmeister.Spell.Platform.Private.Loader {

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
			throw 'Error: Sound loading is not yet implemented.'
		}
	}
}
