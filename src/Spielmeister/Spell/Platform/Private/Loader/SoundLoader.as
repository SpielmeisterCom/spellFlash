package Spielmeister.Spell.Platform.Private.Loader {

	public class SoundLoader implements Loader {
		private var host : String
		private var onCompleteCallback : Function


		public function SoundLoader( eventManager : Object, host : String, resourceBundleName : String, resourceUri : String, callback : Function, soundManager : Object ) {
			this.host               = host
			this.onCompleteCallback = callback
		}

		public function start() : void {
//			trace( 'Soundloader.start() - not yet implemented')

			onCompleteCallback( {
				thisIsAStub: 'sound_loading_is_not_yet_implemented'
			} )
		}
	}
}
