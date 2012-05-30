package Spielmeister {

	public class Needjs {

		private var need : Object


		public function Needjs() {
			need = {
				modules: {}
			}
		}


		private function resolveDependencies ( moduleName : String, ... variableArguments ) : Object {
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


		public function createDefine() {
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

				need.modules[ name ] = module
			}
		}


		public function createRequire() {
			return function( moduleName ) {
				if( !moduleName ) throw 'No module name provided.'


				var module = need.modules[ moduleName ]

				if( !module ) throw 'Could not resolve module name \'' + moduleName + '\' to module instance.'


				if( !module.instance ) {
					module.instance = resolveDependencies( moduleName )
				}

				return module.instance
			}
		}


		public function createEnterMain() {
			return function( mainModuleName, args ) {
				resolveDependencies( mainModuleName, args )
			}
		}
	}
}
