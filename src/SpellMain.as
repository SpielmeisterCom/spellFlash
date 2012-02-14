package {
	import Spielmeister.ModuleDefinitions
	import Spielmeister.Needjs

	import flash.display.*
	import flash.system.Security


	public class SpellMain extends Sprite {

		public function SpellMain() {
			// stage setup
			this.stage.align     = StageAlign.TOP_LEFT
			this.stage.scaleMode = StageScaleMode.NO_SCALE


			var needjs : Needjs = new Needjs()

			var moduleDefinitions : ModuleDefinitions = new ModuleDefinitions(
				this.root,
				this.stage,
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
