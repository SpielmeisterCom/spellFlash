package Spielmeister.Spell.Platform.Private.Graphics {
	import net.richardlord.coral.Matrix3d

	/**
	 * The state stack supplies means to save and restore state information in a stack-like fashion without allocations at runtime.
	 */
	public class StateStack {
		private var depth : uint
		private var stack : Vector.<StateStackElement>
		private var index : uint

		public function StateStack( depth : uint ) {
			this.depth = depth
			this.stack = new Vector.<StateStackElement>( depth )

			// initializing stack
			for( var i : Number = 0; i < depth; i++ ) {
				stack[ i ] = createDefaultState()
			}
		}

		public function pushState() : StateStackElement {
			if( index === depth -1 ) throw 'Can not push state. Maximum state stack depth of ' + depth + ' was reached.'

			copyState( stack[ index ], stack[ ++index ] )
			return stack[ index ]
		}

		public function popState() : StateStackElement {
			if( index < 0 ) throw 'Can not pop state. The state stack is already depleted.'

			index--
			return stack[ index ]
		}

		private function createDefaultState() : StateStackElement {
			return new StateStackElement( 1.0, 0xffffff, new Matrix3d() )
		}

		private function copyState( source : StateStackElement, destination : StateStackElement ) : void {
			destination.opacity = source.opacity
			destination.color   = source.color
			destination.matrix  = source.matrix.clone()
		}
	}
}
