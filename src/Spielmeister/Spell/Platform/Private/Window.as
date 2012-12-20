package Spielmeister.Spell.Platform.Private {

	import flash.net.*

	public class Window {


		public function Window() {
		}

		public function open( href: String ) : void {
			var url:URLRequest = new URLRequest( href )
			navigateToURL(url, "_blank")
		}
	}
}
