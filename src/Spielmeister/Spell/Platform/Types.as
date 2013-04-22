package Spielmeister.Spell.Platform {

	import Spielmeister.Spell.Platform.Private.*


	public class Types {
		private var time : TimeImpl = new TimeImpl()


		public function Types() {}

		public function createFloatArray( length : uint ) : Array {
			return new Array( length )
		}

		public function hasFloatArraySupport() : Boolean {
			return false
		}

		public function get Int8Array() : Object {
			return {
				isSupported : function() : Boolean {
					return false
				},
				create : function( length : Number ) : Array {
					return new Array( length )
				},
				fromValues : function( values : Array ) : Array {
					return values.slice( 0 )
				}
			}
		}

		public function get Int32Array() : Object {
			return {
				isSupported : function() : Boolean {
					return false
				},
				create : function( length : Number ) : Array {
					return new Array( length )
				},
				fromValues : function( values : Array ) : Array {
					return values.slice( 0 )
				}
			}
		}

		public function get Time() : TimeImpl {
			return time
		}
	}
}
