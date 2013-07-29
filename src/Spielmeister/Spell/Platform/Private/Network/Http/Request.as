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
			if( !method ) {
				throw 'method is undefined.'
			}

			if( method !== 'GET' &&
				method !== 'POST' ) {

				throw 'The provided method is not supported.'
			}

			if( !url ) {
				throw 'url is undefined.'
			}

			var data : Object        = rest.length == 1 ? rest[ 0 ] : undefined,
				onLoad : Function    = rest.length == 2 ? rest[ 1 ] : undefined,
				onError : Function   = rest.length == 3 ? rest[ 2 ] : undefined,
				request : URLRequest = new URLRequest( url )

			request.method = method === 'GET' ?
				URLRequestMethod.GET :
				URLRequestMethod.POST

			if( data ) {
				request.data = createData( data )
			}

			var loader : URLLoader = new URLLoader()

			if( onLoad ) {
				loader.addEventListener(
					Event.COMPLETE,
					function( event : Event ) : void {
						onLoad( loader.data )
					}
				)
			}

			if( onError ) {
				loader.addEventListener(
					IOErrorEvent.IO_ERROR,
					function( event : IOErrorEvent ) : void {
						onError( 'Error while accessing ' + url )
					}
				)
			}

			loader.load( request )
		}
	}
}
