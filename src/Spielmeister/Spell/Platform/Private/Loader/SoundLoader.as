package Spielmeister.Spell.Platform.Private.Loader {

	public class SoundLoader implements Loader {
		private var onCompleteCallback : Function


		public function SoundLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) {
			onCompleteCallback = callback
		}

		public function start() : void {
			trace( 'Soundloader.start() - not yet implemented')

			onCompleteCallback(
				{
					thisIsAStub: 'sound_loading_is_not_yet_implemented'
				}
			)
		}
	}
}
