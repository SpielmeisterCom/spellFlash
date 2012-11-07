package Spielmeister.Spell.Platform.Private.Box2D {
	import Box2D.Dynamics.b2ContactListener
	import Box2D.Dynamics.b2ContactImpulse
	import Box2D.Dynamics.Contacts.b2Contact
	import Box2D.Collision.b2Manifold

	public class ContactListenerWrapper extends b2ContactListener {
		private var beginContact : Function
		private var endContact : Function
		private var preSolve : Function
		private var postSolve : Function

		public function ContactListenerWrapper(  beginContact : Function, endContact : Function, preSolve : Function, postSolve : Function ) {
			this.beginContact = beginContact
			this.endContact   = endContact
			this.preSolve     = preSolve
			this.postSolve    = postSolve
		}

		public override function BeginContact( contact : b2Contact ) : void {
			if( this.beginContact ) this.beginContact( contact )
		}

		public override function EndContact( contact : b2Contact ) : void {
			if( this.endContact ) this.endContact( contact )
		}

		public override function PreSolve( contact : b2Contact, oldManifold : b2Manifold ) : void {
			if( this.preSolve ) this.preSolve( contact, oldManifold )
		}

		public override function PostSolve( contact : b2Contact, impulse : b2ContactImpulse ) : void {
			if( this.postSolve ) this.postSolve( contact, impulse )
		}
	}
}
