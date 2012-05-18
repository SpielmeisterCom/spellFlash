package Spielmeister {
	import Spielmeister.PlatformAdapter
	import Spielmeister.Needjs

	import flash.display.Sprite
	import flash.text.TextField

	public class SpellMain extends Sprite {

		public function SpellMain() : void {
			var needjs : Needjs = new Needjs()

			var spellEngine : SpellEngine = new SpellEngine()
			spellEngine.load( needjs.createDefine(), needjs.createRequire() )

			var runtimeModule : RuntimeModule = new RuntimeModule()
			runtimeModule.load( needjs.createDefine(), needjs.createRequire() )

			var platformAdapter : PlatformAdapter = new PlatformAdapter(
				this.stage,
				this.root,
				this.loaderInfo.loaderURL,
				this.loaderInfo.parameters
			)

			platformAdapter.load( needjs.createDefine(), needjs.createRequire() )

			var enterMain : Function = needjs.createEnterMain()

//			enterMain( "spell/client/renderingTestMain" )
//			enterMain( 'spell/client/renderingCoordinateTestMain' )
			enterMain( 'spell/client/main' )


			var display_txt:TextField = new TextField();
			display_txt.text = "Hello World!";
			addChild(display_txt);
		}
	}
}
