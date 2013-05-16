package Spielmeister {
	import flash.display.Sprite

	public class SpellMain extends Sprite {
		private static const anonymizeModuleIds : Boolean = CONFIG::anonymizeModuleIds

		public function SpellMain() : void {
			var needjs : Needjs = new Needjs()

			needjs.load( new SpellEngine() )
			needjs.load( new ScriptModules() )
			needjs.load(
				new PlatformAdapter( this.stage, this.root, this.loaderInfo.loaderURL, needjs, anonymizeModuleIds ),
				anonymizeModuleIds
			)

			var require : Function = needjs.createRequire()
			var applicationData : ApplicationData = new ApplicationData()

			var main : Object = require( 'spell/client/main', this.loaderInfo.parameters )
			main.start( applicationData.getApplicationModule(), applicationData.getCacheContent() )
		}
	}
}
