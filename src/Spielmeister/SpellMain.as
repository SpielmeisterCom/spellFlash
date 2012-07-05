package Spielmeister {
	import flash.display.Sprite

	public class SpellMain extends Sprite {

		public function SpellMain() : void {
			var needjs : Needjs = new Needjs()
			var define : Function = needjs.createDefine()
			var require : Function = needjs.createRequire()

			var platformAdapter : PlatformAdapter = new PlatformAdapter( this.stage, this.root, this.loaderInfo.loaderURL )
			platformAdapter.load( define, require )

			var spellEngine : SpellEngine = new SpellEngine()
			spellEngine.load( define, require )

			var runtimeModule : RuntimeModule = new RuntimeModule()
			runtimeModule.load( define, require )

//			enterMain( "spell/client/renderingTestMain" )
//			enterMain( 'spell/client/renderingCoordinateTestMain' )
			var main = require( 'spell/client/main', this.loaderInfo.parameters )
			main.start()
		}
	}
}
