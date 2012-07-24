package Spielmeister.Spell.Platform.Private.Graphics {

	import flash.display.Stage

	import Spielmeister.Spell.Platform.Private.Graphics.DisplayList.DisplayListContext


	public class RenderingFactoryImpl {
		public const BACK_END_DISPLAY_LIST : uint = 0
		public const BACK_END_STAGE_3D : uint = 1

		private var stage : Stage


		public function RenderingFactoryImpl( stage : Stage ) {
			this.stage = stage
		}

		public function createContext2d( eventManager : Object, id : String, width : uint, height : uint, requestedBackEnd : uint = BACK_END_DISPLAY_LIST ) : DisplayListContext {
			return new DisplayListContext( this.stage, width, height )
		}
	}
}
