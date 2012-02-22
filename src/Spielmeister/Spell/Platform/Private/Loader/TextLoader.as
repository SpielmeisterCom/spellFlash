package Spielmeister.Spell.Platform.Private.Loader {

	public class TextLoader implements Loader {
		private var host : String
		private var onCompleteCallback : Function


		public function TextLoader( eventManager : Object, host : String, resourceBundleName : String, resourceUri : String, callback : Function ) {
			this.host               = host
			this.onCompleteCallback = callback
		}

		public function start() : void {

		}
	}
}
