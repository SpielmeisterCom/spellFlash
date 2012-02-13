package Spielmeister.Spell.Platform.Private {
import Spielmeister.Underscore

	public class Lobby {
		private var eventManager : Object
		private var connection : Object
		// TODO: find solution for this
		private var _ : Underscore


		public function Lobby( eventManager : Object, connection : Object ) {
			this.eventManager = eventManager
			this.connection   = connection
			this._            = new Underscore()
		}

		public function init() : void {
			this.eventManager.subscribe(
				[ 'messageReceived', 'setName' ],
				_.bind(
					function( messageType : String , messageData : String ) : void {
						this.connection.send( 'createGame' )
					},
					this
				)
			)
		}

		public function setVisible( value : Boolean ) : void {

		}

		public function setNoGamesOptionVisibility( value : Boolean ) : void {

		}

		public function refreshGameList( games : Object ) : void {
			var game : Object = _.last( games )

			this.connection.send( 'selectGame', game.game.name )
			this.connection.send( 'startGame', game.game.name )
		}
	}
}
