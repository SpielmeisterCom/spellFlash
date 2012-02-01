package {
	import flash.display.*

	import Spielmeister.ModuleDefinitions
	import Spielmeister.Needjs

import flash.system.Security


public class SpellMain extends Sprite {

		public function SpellMain() {
			// stage setup
			this.stage.align = StageAlign.TOP_LEFT
			this.stage.scaleMode = StageScaleMode.NO_SCALE

			Security.allowDomain("*");
			Security.loadPolicyFile("xmlsocket://127.0.0.1:10843");

			if( !Function.prototype.bind ) {
				Function.prototype.bind = function() : Function {
					var functionObject : Object = this
					var scope : Object = arguments.shift()

					return function() : * {
						return functionObject.apply( scope, arguments )
					}
				}
			}

			var needjs : Needjs = new Needjs()

			var moduleDefinitions : ModuleDefinitions = new ModuleDefinitions(
				this.root,
				needjs.createDefine(),
				needjs.createRequire()
			)

			moduleDefinitions.loadModuleDefinitions()


			var enterMain : Function = needjs.createEnterMain()

//			enterMain( "spell/client/renderingTestMain" )
			enterMain( "funkysnakes/client/main" )
		}
	}
}
