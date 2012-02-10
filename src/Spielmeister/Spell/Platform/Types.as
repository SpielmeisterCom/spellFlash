package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.*


	public class Types {
		private var time : TimeImpl = new TimeImpl()


		public function Types() {}

		public function createNativeFloatArray( length : uint ) : Array {
			return new Array( length )
		}

		public function createLobby( eventManager : Object, connection : Object ) : Lobby {
			return new Lobby( eventManager, connection )
		}

		public function get Time() : TimeImpl {
			return time
		}
	}
}
