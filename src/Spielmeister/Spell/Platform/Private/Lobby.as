package Spielmeister.Spell.Platform.Private {

	import Spielmeister.Underscore

	import flash.display.DisplayObject
	import flash.display.Sprite
	import flash.events.MouseEvent

	import mx.collections.ArrayCollection
	import mx.core.UIComponent

	import spark.components.*
	import spark.events.*
	import spark.utils.DataItem


	public class Lobby {
		private var root : Sprite
		private var eventManager : Object
		private var connection : Object

		// ui
		private var ui : UIComponent
		private var playerNameTextInput : TextInput
		private var gamesList : List
		private var knownGames : Object = {}
		private var createGameButton : Button
		private var startGameButton : Button


		// TODO: find solution for this
		private var _ : Underscore


		public function Lobby( root : DisplayObject, eventManager : Object, connection : Object ) {
			this.root         = Sprite( root )
			this.eventManager = eventManager
			this.connection   = connection
			this._            = new Underscore()

			this.ui = createUI()
		}


		private function nameChangeHandler( event : TextOperationEvent ) : void {
			var newPlayerName : String = event.target.text

			if( newPlayerName === '' ) {
				createGameButton.enabled = false

			} else {
				createGameButton.enabled = true
				connection.send( 'changeName', newPlayerName )
			}
		}


		private function selectGameHandler( event : IndexChangeEvent ) : void {
			if( event.newIndex !== -1 ) {
				var selectedGame : Object = getSelectedGameByListIndex( event.newIndex )

				if( !selectedGame ||
					selectedGame.numberOfPlayers >= 4 ) {

					startGameButton.enabled = false
					return
				}

				this.connection.send( "selectGame", selectedGame.name )
				startGameButton.enabled = true

			} else {
				startGameButton.enabled = false
			}
		}


		private function createGameHandler( event : MouseEvent ) : void {
			connection.send( 'createGame' )
		}


		private function startGameHandler( event : MouseEvent ) : void {
			var selectedGame : Object = getSelectedGameByListIndex( gamesList.selectedIndex )
			this.connection.send( 'startGame', selectedGame.name )
		}


		private function getSelectedGameByListIndex( index : int ) : Object {
			return _.find(
				knownGames,
				function( iter ) {
					return ( iter.index === index )
				}
			)
		}


		private function createUI() : UIComponent {
			var container : VGroup = new VGroup()
			container.opaqueBackground = 0xffffff


			var yourNameLabel : Label = new Label()
			yourNameLabel.text = 'Your name:'

			playerNameTextInput = new TextInput()
			playerNameTextInput.addEventListener( TextOperationEvent.CHANGE, nameChangeHandler )


			var existingGamesLabel : Label = new Label()
			existingGamesLabel.text = 'Existing games:'

			gamesList = new List()
			gamesList.dataProvider = new ArrayCollection()
			gamesList.addEventListener( IndexChangeEvent.CHANGE, selectGameHandler )


			var hgroup : HGroup = new HGroup()

			createGameButton = new Button()
			createGameButton.label = 'Create game'
			createGameButton.enabled = false
			createGameButton.addEventListener( MouseEvent.CLICK, createGameHandler )

			startGameButton = new Button()
			startGameButton.label = 'Start game'
			startGameButton.enabled = false
			startGameButton.addEventListener( MouseEvent.CLICK, startGameHandler )

			hgroup.addElement( createGameButton )
			hgroup.addElement( startGameButton )


			container.addElement( yourNameLabel )
			container.addElement( playerNameTextInput )
			container.addElement( existingGamesLabel )
			container.addElement( gamesList )
			container.addElement( hgroup )


			return container
		}


		public function init() : void {
			this.eventManager.subscribe(
				[ 'messageReceived', 'setName' ],
				_.bind(
					function( messageType : String , messageData : String ) : void {
						playerNameTextInput.text = messageData
						createGameButton.enabled = true
					},
					this
				)
			)
		}


		public function setVisible( value : Boolean ) : void {
			if( value ) {
				this.root.addChild( this.ui )

			} else {
				this.root.removeChild( this.ui )
			}
		}


		public function setNoGamesOptionVisibility( value : Boolean ) : void {

		}


		public function refreshGameList( games : Object ) : void {
			_.each(
				games,
				function( game ) {
					if( !game.game.hasChanged ) return


					var name            = game.game.name
					var numberOfPlayers = _.size( game.game.players )
					var playersText     = ( numberOfPlayers === 1 ? 'player' : 'players' )
					var label           = name + ' (' + numberOfPlayers + ' ' + playersText + ')'

					if( !_.has( knownGames, game.game.id ) ) {
						// add game
						knownGames[ game.game.id ] = {
							id              : game.game.id,
							name            : game.game.name,
							numberOfPlayers : numberOfPlayers,
							index           : gamesList.dataProvider.length // the index in the spark component list
						}

						var dataItem : DataItem = new DataItem()
						dataItem.label  = label

						gamesList.dataProvider.addItem( dataItem )


					} else {
						// update game
						var knownGame = knownGames[ game.game.id ]

						if( !knownGame ) return


						game.numberOfPlayers = numberOfPlayers

						var item : Object = gamesList.dataProvider.getItemAt( knownGame.index )
						item.label = label

						gamesList.dataProvider.setItemAt( item, knownGame.index )
					}

					game.game.hasChanged = false
				}
			)


			// remove games that are not available for joining anymore
			var removedIndices : Array = new Array()

			for( var i in knownGames ) {
				var knownGame : Object = knownGames[ i ]

				if( games[ knownGame.name ] === undefined ) {
					removedIndices.push( knownGame.index )

					gamesList.dataProvider.removeItemAt( knownGame.index )
					delete knownGames[ i ]
				}
			}


			// Do some housekeeping. Indices into the data provider have to be updated when items are removed from it.
			if( removedIndices.length === 0 ) return

			removedIndices.sort()

			for( var i in knownGames ) {
				knownGame = knownGames[ i ]

				// the number of removed indices that are smaller than the current DataItem index
				var numberofIndicesRemoved : int = _.reduce(
					removedIndices,
					function( memo, iter ) {
						if( iter < knownGame.index ) memo++

						return memo
					},
					0
				)

				knownGame.index -= numberofIndicesRemoved
			}
		}
	}
}
