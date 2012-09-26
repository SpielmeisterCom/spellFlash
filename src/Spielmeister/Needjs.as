package Spielmeister {

	import com.hurlant.crypto.hash.SHA256
	import com.hurlant.util.Base64
	import flash.utils.ByteArray

	public class Needjs {
		private var modules : Object = {}

		public function getModuleInstanceById( id : String, anonymizeModuleIds : Boolean = false ) : Object {
			id = anonymizeModuleIds ? hashModuleId( id ) : id

			var moduleInstance = require( id, null )

			if( !moduleInstance ) throw 'Could not resolve module name \'' + id + '\' to module instance.'

			return moduleInstance
		}

		private function hashModuleId( id : String ) : String {
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

			var module : Object = modules[ moduleName ]

			if( module === null ||
				module.definition === undefined ) {

				throw "Unable to find module definition for module '" + moduleName + "'."
			}


			var dependencies = module.definition[ 0 ]
			var callback     = module.definition[ 1 ]

			var args = []

			for( var i = 0; i < dependencies.length; i++ ) {
				var name = dependencies[ i ]

				if( modules[ name ] === undefined ) {
					throw 'Could not find module definition for dependency "' + name + '" of module "' + moduleName + '" . Is it included and registered via define?'
				}

				if( modules[ name ].instance === undefined ) {
					modules[ name ].instance = resolveDependencies( dependencies[ i ], null )
				}

				args.push(
					modules[ name ].instance
				)
			}

			if( config ) {
				args.push( config )
			}

			return callback.apply( null, args )
		}

		/**
		 * Creates a define function. If anonymizeModuleIds is set to true all module names are anonymized. The dependency module identifiers are left
		 * unchanged.
		 *
		 * @param {Boolean} anonymizeModuleIds
		 */
		private function createDefine( anonymizeModuleIds : Boolean = false ) {
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

				if( anonymizeModuleIds ) {
					name = hashModuleId( name )
				}

				modules[ name ] = module
			}
		}

		private function require( moduleName : String, ... rest ) {
			var args   = rest.length >= 1  ? rest[ 0 ] : null
			var config = rest.length === 2 ? rest[ 1 ] : null

			if( !moduleName ) throw 'No module name provided.'


			var module = modules[ moduleName ]

			if( !module ) throw 'Could not resolve module name \'' + moduleName + '\' to module instance.'


			if( !module.instance ) {
				module.instance = resolveDependencies( moduleName, args )
			}

			return module.instance
		}

		public function createRequire() {
			return this.require
		}

		public function load( moduleDefinition : ModuleDefinition, anonymizeModuleIds : Boolean = false ) {
			moduleDefinition.load(
				this.createDefine( anonymizeModuleIds ),
				this.createRequire()
			)
		}
	}
}
