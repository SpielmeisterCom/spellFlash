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

		private function resolveDependencies( name : String, ... variableArguments ) : Object {
			if( name === '' ) {
				throw 'No module name was provided.'
			}

			if( variableArguments.length === 1 ) {
				var config : Object = variableArguments[ 0 ]
			}

			var module : Object = modules[ name ]

			if( module === null ||
				module.definition === undefined ) {

				throw 'Unable to find module definition for module \'' + name + '\'.'
			}


			var dependencies = module.definition[ 0 ]
			var callback     = module.definition[ 1 ]

			var args = []

			for( var i = 0; i < dependencies.length; i++ ) {
				var dependencyName   = dependencies[ i ],
					dependencyModule = modules[ dependencyName ]

				if( !dependencyModule ) {
					throw 'Could not find module definition for dependency "' + dependencyName + '" of module "' + name + '" . Is it included and registered via define?'
				}

				if( !dependencyModule.instance ) {
					dependencyModule.instance = resolveDependencies( dependencies[ i ], null )
				}

				args.push(
					 dependencyModule.instance
				)
			}

			if( config ) {
				args.push( config )
			}

			return callback.apply( null, args )
		}

		var createModuleInstance = function( dependencies, body, args, config ) {
			var moduleInstanceArgs = []

			if( dependencies ) {
				for( var i = 0; i < dependencies.length; i++ ) {
					var dependencyName   = dependencies[ i ],
						dependencyModule = modules[ dependencyName ]

					if( !dependencyModule && config.hashModuleId ) {
						dependencyModule = modules[ config.hashModuleId( dependencyName ) ]
					}

					if( !dependencyModule ) {
						dependencyModule = modules[ dependencyName ]
					}

					if( !dependencyModule.instance ) {
						dependencyModule.instance = createModuleInstance( dependencyModule.dependencies, dependencyModule.body, undefined, config )
					}

					moduleInstanceArgs.push( dependencyModule.instance )
				}
			}

			if( args ) moduleInstanceArgs.push( args )

			return body.apply( null, moduleInstanceArgs )
		}

		/**
		 * Creates a define function. If anonymizeModuleIds is set to true all module names are anonymized. The dependency module identifiers are left
		 * unchanged.
		 *
		 * @param {Boolean} anonymizeModuleIds
		 */
		public function createDefine( anonymizeModuleIds : Boolean = false ) {
			return function( name ) {
				var numArguments = arguments.length

				if( numArguments < 2 ||
					numArguments > 3 ) {

					throw 'Error: Module definition is invalid.'
				}

				var module = {
					body         : ( numArguments === 2 ? arguments[ 1 ] : arguments[ 2 ] ),
					dependencies : ( numArguments === 2 ? undefined : arguments[ 1 ] )
				}

				if( anonymizeModuleIds ) {
					name = hashModuleId( name )
				}

				modules[ name ] = module
			}
		}

		private function require( name : String, ... rest ) {
            if( !name ) throw 'No module name provided.'

			var args   = rest.length >= 1  ? rest[ 0 ] : null,
			    config = rest.length === 2 ? rest[ 1 ] : null,
                module = modules[ name ]

            if( !module && config.hashModuleId ) {

				trace( 'trying hashed name: ' + config.hashModuleId( name ) )

                module = modules[ config.hashModuleId( name ) ]
            }

			if( !module ) throw 'Could not resolve module name \'' + name + '\' to module instance.'

			if( !module.instance ) {
				module.instance = createModuleInstance( module.dependencies, module.body, args, config )
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
