package Spielmeister {

	import com.hurlant.crypto.hash.SHA256
	import com.hurlant.util.Base64
	import flash.utils.ByteArray

	public class Needjs {

		private var need : Object


		public function Needjs() {
			need = {
				modules: {}
			}
		}


		private function hashModuleIdentifier( id : String ) : String {
			var sha256 : SHA256 = new SHA256()
			var bytes : ByteArray = new ByteArray()
			bytes.writeUTFBytes( id )

			return Base64.encodeByteArray( sha256.hash( bytes ) )
		}


		private function resolveDependencies( moduleName : String, ... variableArguments ) : Object {
			if( moduleName === "" ) {
				throw "No module name was provided."
			}

			if( variableArguments.length === 1 ) {
				var config : Object = variableArguments[ 0 ]
			}

			var module : Object = need.modules[ moduleName ]

			if( module === null ||
				module.definition === undefined ) {

				throw "Unable to find module definition for module '" + moduleName + "'."
			}


			var dependencies = module.definition[ 0 ]
			var callback     = module.definition[ 1 ]

			var args = []

			for( var i = 0; i < dependencies.length; i++ ) {
				var name = dependencies[ i ]

				if( need.modules[ name ] === undefined ) {
					throw 'Could not find module definition for dependency "' + name + '" of module "' + moduleName + '" . Is it included and registered via define?'
				}

				if( need.modules[ name ].instance === undefined ) {
					need.modules[ name ].instance = resolveDependencies( dependencies[ i ], null )
				}

				args.push(
					need.modules[ name ].instance
				)
			}

			if( config ) {
				args.push( config )
			}

			return callback.apply( null, args )
		}


		/**
		 * Creates a define function. If anonymizeModuleIdentifiers is set to true all module names are anonymized. The dependency module identifiers are left
		 * unchanged.
		 *
		 * @param {Boolean} anonymizeModuleIdentifiers
		 */
		public function createDefine( anonymizeModuleIdentifiers : Boolean = false ) {
			return function( name, dependencies, callback ) {
				if( arguments.length < 2 ||
					arguments.length > 3 ) {

					throw "Definition is invalid."
				}


				if( arguments.length === 2 ) {
					// No dependencies were provided. Thus arguments looks like this [ name, constructor ].

					callback = dependencies
					dependencies = []
				}

				var module = {
					definition: [ dependencies, callback ]
				}

				if( anonymizeModuleIdentifiers ) {
					name = hashModuleIdentifier( name )
				}

				need.modules[ name ] = module
			}
		}


		public function createRequire() {
			return function( moduleName, args ) {
				if( !moduleName ) throw 'No module name provided.'


				var module = need.modules[ moduleName ]

				if( !module ) throw 'Could not resolve module name \'' + moduleName + '\' to module instance.'


				if( !module.instance ) {
					module.instance = resolveDependencies( moduleName, args )
				}

				return module.instance
			}
		}
	}
}
