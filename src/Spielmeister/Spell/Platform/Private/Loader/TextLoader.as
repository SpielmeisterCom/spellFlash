package Spielmeister.Spell.Platform.Private.Loader {

	public class TextLoader implements Loader {
		private var libraryUrl : String
		private var libraryPath : String
		private var onLoadCallback : Function
		private var onErrorCallback : Function

		public function TextLoader( libraryUrl : String, libraryPath : String, onLoadCallback : Function, onErrorCallback : Function, onTimedOutCallback : Function ) {
			this.libraryUrl      = libraryUrl
			this.libraryPath     = libraryPath
			this.onLoadCallback  = onLoadCallback
			this.onErrorCallback = onErrorCallback
		}

		public function start() : void {
			throw 'Error: Text loading is not yet implemented.'
		}
	}
}
