package {
	import Spielmeister.ModuleDefinitions;
	import Spielmeister.Needjs;

	import flash.display.Sprite;


	public class SpellMain extends Sprite {

		public function SpellMain() {
			var needjs : Needjs = new Needjs()

			var moduleDefinitions : ModuleDefinitions = new ModuleDefinitions(
				needjs.createDefine(),
				needjs.createRequire()
			)

			moduleDefinitions.loadModuleDefinitions()


			var enterMain : Function = needjs.createEnterMain()

			enterMain( "testModule" )
		}
	}
}
