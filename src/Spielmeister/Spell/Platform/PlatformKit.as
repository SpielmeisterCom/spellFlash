package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.TimeImpl


	public class PlatformKit {

		public var Time : TimeImpl = new TimeImpl()


		public function createNativeFloatArray( length : uint ) : Array {
			return new Array( length )
		}

		public function createCallNextFrame() : Function {
			return function() : void {}
		}
	}
}
