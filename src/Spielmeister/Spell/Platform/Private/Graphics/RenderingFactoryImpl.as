package Spielmeister.Spell.Platform.Private.Graphics {

	import flash.display.DisplayObject

	import Spielmeister.Spell.Platform.Private.Graphics.DisplayList.DisplayListContext


	public class RenderingFactoryImpl {
		public const BACK_END_DISPLAY_LIST : uint = 0
		public const BACK_END_STAGE_3D : uint = 1

		private var root : DisplayObject


		public function RenderingFactoryImpl( root : DisplayObject ) {
			this.root = root
		}

		public function createContext2d( width : uint, height : uint, id : String, requestedBackEnd : uint ) : DisplayListContext {
			return new DisplayListContext( this.root )
		}
	}
}
