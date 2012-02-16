package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.*


	public class Types {
		private var time : TimeImpl = new TimeImpl()


		public function Types() {}

		public function createNativeFloatArray( length : uint ) : Array {
			return new Array( length )
		}

		public function get Time() : TimeImpl {
			return time
		}
	}
}
