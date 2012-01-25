package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.TimeImpl


	public class Types {
		public var Time : TimeImpl = new TimeImpl()

		public function createNativeFloatArray( length : uint ) : Array {
			trace( "createNativeFloatArray" )


			return new Array( length )
		}

		public function createLobby() : void {
			trace( "createLobby" )
		}
	}
}
