package Spielmeister.Spell.Platform.Private {

	public class Lobby {
		private var eventManager : Object
		private var connection : Object


		public function Lobby( eventManager : Object, connection : Object ) {
			this.eventManager = eventManager
			this.connection   = connection
		}

		public function init() : void {
			this.eventManager.subscribe(
				[ "messageReceived", "setName" ],
				function( messageType, messageData ) {
					trace( 'Lobby: My name is ' + messageData + '.' )
				}
			)
		}

		public function setVisible( value : Boolean ) : void {

		}

		public function setNoGamesOptionVisibility( value : Boolean ) : void {

		}

		public function refreshGameList( ) : void {

		}
	}
}
