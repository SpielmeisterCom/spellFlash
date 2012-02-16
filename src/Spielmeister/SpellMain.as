package Spielmeister {
	import Spielmeister.ModuleDefinitions
	import Spielmeister.Needjs

	import mx.core.Application


	public class SpellMain extends Application {

		public function run() : void {
			var needjs : Needjs = new Needjs()

			var moduleDefinitions : ModuleDefinitions = new ModuleDefinitions(
				this.stage,
				this.root,
				this.rawChildren,
				this.loaderInfo.loaderURL,
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
