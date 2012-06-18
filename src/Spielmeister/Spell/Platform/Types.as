package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.*


	public class Types {
		private var time : TimeImpl = new TimeImpl()


		public function Types() {}

		public function createFloatArray( length : uint ) : Array {
			return new Array( length )
		}

		public function createIntegerArray( length : uint ) : Array {
			return new Array( length )
		}

		public function hasFloatArraySupport() : Boolean {
			return false
		}

		public function hasIntegerArraySupport() : Boolean {
			return false
		}

		public function get Time() : TimeImpl {
			return time
		}
	}
}
