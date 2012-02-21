package Spielmeister.Spell.Platform.Private.Graphics {

	import flash.display.DisplayObject

	import Spielmeister.Spell.Platform.Private.Graphics.DisplayList.DisplayListContext

import mx.core.IChildList


	public class RenderingFactoryImpl {
		public const BACK_END_DISPLAY_LIST : uint = 0
		public const BACK_END_STAGE_3D : uint = 1

		private var container : IChildList


		public function RenderingFactoryImpl( container : IChildList ) {
			this.container = container
		}

		public function createContext2d( width : uint, height : uint, requestedBackEnd : uint = BACK_END_DISPLAY_LIST, id : String = null ) : DisplayListContext {
			return new DisplayListContext( container, width, height )
		}
	}
}
