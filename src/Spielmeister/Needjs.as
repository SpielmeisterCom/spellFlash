package Spielmeister {

	public class Needjs {

		private var need : Object


		public function Needjs() {
			need = {
				modules: {}
			}
		}


		private function resolveDependencies ( moduleName : String ) : Object {
			if( moduleName === "" ) {
				throw "No module name was provided."
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
					throw 'Could not find module definition for "' + name + '". Is it included and registered via define?'
				}

				if( need.modules[ name ].instance === undefined ) {
					need.modules[ name ].instance = resolveDependencies( dependencies[ i ] )
				}

				args.push(
					need.modules[ name ].instance
				)
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
			return function( dependencies, callback ) {
				if( dependencies === undefined ||
					callback === undefined ) {

					throw "The provided arguments do not match."
				}


				var args = []

				for( var i = 0; i < dependencies.length; i++ ) {
					args.push(
						resolveDependencies( dependencies[ i ] )
					)
				}


				callback.apply( null, args )
			}
		}


		public function createEnterMain() {
			return function( mainModuleName ) {
				resolveDependencies( mainModuleName )
			}
		}
	}
}
