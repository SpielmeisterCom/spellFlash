package Spielmeister.Spell.Platform.Private.Loader {

	public class TextLoader implements Loader {
		private var url : String
		private var onLoadCallback : Function
		private var onErrorCallback : Function

		public function TextLoader( url : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) {
			this.url             = url
			this.onLoadCallback  = onLoadCallback
			this.onErrorCallback = onErrorCallback
		}

		public function start() : void {
			throw 'Error: Text loading is not yet implemented.'
		}
	}
}
