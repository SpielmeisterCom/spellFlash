package Spielmeister {

	import Spielmeister.Spell.Platform.*

	import flash.display.*


	public class PlatformAdapter implements ModuleDefinition {
		private var platformKit : PlatformKit

		public function PlatformAdapter ( stage : Stage, root : DisplayObject, loaderURL : String, needjs : Needjs, anonymizeModuleIds : Boolean = false ) {
			this.platformKit = new PlatformKit(
				stage,
				root,
				loaderURL,
				needjs.getModuleInstanceById( 'spell/shared/util/Events', anonymizeModuleIds )
			)

			this.platformKit.init()
		}

		private function createPlatformKit() : PlatformKit {
			return platformKit
		}

		public function load( define : Function, require : Function ) : void {
			define(
				"spell/shared/util/platform/private/functions",
				function() : Underscore {
					return new Underscore()
				}
			)

			define(
				"spell/shared/util/platform/private/initDebugEnvironment",
				function() : Function {
					return function() : void {}
				}
			)

			define(
				"spell/shared/util/platform/PlatformKit",
				createPlatformKit
			)

			define(
				"spell/shared/util/platform/Types",
				function() : Types {
					return new Types()
				}
			)

			define(
				"spell/shared/util/platform/log",
				function() : Function {
					return function( message : String ) : void {
						trace( message )
					}
				}
			)
		}
	}
}
