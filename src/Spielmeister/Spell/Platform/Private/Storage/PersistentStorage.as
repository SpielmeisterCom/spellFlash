package Spielmeister.Spell.Platform.Private.Storage {
	import flash.net.SharedObject;

	public class PersistentStorage {
		private var storage : SharedObject

		public function PersistentStorage() {
			storage = SharedObject.getLocal( 'SpellJS' )
		}

		public function set( key : String, value : * ) : void {
			storage.data[ key ] = value
			storage.flush()
		}

		public function get( key : String ) : * {
			return storage.data[ key ]
		}

		public function clear( key : String ) : void {
			delete storage.data[ key ]
			storage.flush()
		}
	}
}
