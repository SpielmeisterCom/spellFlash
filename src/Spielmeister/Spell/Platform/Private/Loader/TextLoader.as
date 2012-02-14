package Spielmeister.Spell.Platform.Private.Loader {

	public class TextLoader implements Loader {
		private var serverHostPort : String
		private var onCompleteCallback : Function


		public function TextLoader( serverHostPort : String, eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) {
			this.serverHostPort     = serverHostPort
			this.onCompleteCallback = callback
		}

		public function start() : void {

		}
	}
}
