package Spielmeister.Spell.Platform.Private.Network.Http {

	import flash.events.*
	import flash.net.*


	public class Request {
		public function Request() {
		}

		private static function createData( parameters : Object ) : URLVariables {
			var variables : URLVariables = new URLVariables()

			for( var propertyName in parameters ) {
				variables[ propertyName ] = parameters[ propertyName ]
			}

			return variables
		}

		public static function perform( method : String,  url : String, ... rest ) : void {
			if( !url ) {
				throw 'url is undefined.'
			}

			if( !method ) {
				throw 'method is undefined.'
			}

			if( method !== 'GET' &&
				method !== 'POST' ) {

				throw 'The provided method is not supported.'
			}

			var onLoad : Function   = rest[ 0 ],
				onError : Function  = rest[ 1 ],
				parameters : Object = rest[ 2 ]

			if( !onLoad ) {
				throw 'onLoad is undefined.'
			}


			var request : URLRequest = new URLRequest( url )

			request.method = method === 'GET' ?
				URLRequestMethod.GET :
				URLRequestMethod.POST

			if( parameters ) {
				request.data = createData( parameters )
			}


			var loader : URLLoader = new URLLoader()

			loader.addEventListener(
				Event.COMPLETE,
				function( event : Event ) : void {
					onLoad( loader.data )
				}
			)

			loader.addEventListener(
				IOErrorEvent.IO_ERROR,
				function( event : IOErrorEvent ) : void {
					onError( 'Error while accessing ' + url, event )
				}
			)

			loader.load( request )
		}
	}
}
