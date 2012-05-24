package Spielmeister {
	import flash.display.Sprite

	public class SpellMain extends Sprite {

		public function SpellMain() : void {
			var needjs : Needjs = new Needjs()
			var enterMain : Function = needjs.createEnterMain()

			var spellEngine : SpellEngine = new SpellEngine()
			spellEngine.load( needjs.createDefine(), needjs.createRequire() )

			var runtimeModule : RuntimeModule = new RuntimeModule()
			runtimeModule.load( needjs.createDefine(), needjs.createRequire() )

			var platformAdapter : PlatformAdapter = new PlatformAdapter( this.stage, this.root, this.loaderInfo.loaderURL )
			platformAdapter.load( needjs.createDefine(), needjs.createRequire() )



//			enterMain( "spell/client/renderingTestMain" )
//			enterMain( 'spell/client/renderingCoordinateTestMain' )
			enterMain( 'spell/client/main', this.loaderInfo.parameters )
		}
	}
}
