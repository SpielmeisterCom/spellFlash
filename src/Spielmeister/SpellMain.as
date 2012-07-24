package Spielmeister {
	import flash.display.Sprite

	public class SpellMain extends Sprite {

		private static const anonymizeModuleIdentifiers : Boolean = CONFIG::anonymizeModuleIdentifiers

		public function SpellMain() : void {
			var needjs : Needjs = new Needjs()
			var require : Function = needjs.createRequire()

			var spellEngine : SpellEngine = new SpellEngine()
			spellEngine.load( needjs.createDefine() )

			var runtimeModule : RuntimeModule = new RuntimeModule()
			runtimeModule.load( needjs.createDefine() )

			var platformAdapter : PlatformAdapter = new PlatformAdapter( this.stage, this.root, this.loaderInfo.loaderURL )
			platformAdapter.load( needjs.createDefine( anonymizeModuleIdentifiers ) )

			var main = require( 'spell/client/main', this.loaderInfo.parameters )
			main.start()
		}
	}
}
