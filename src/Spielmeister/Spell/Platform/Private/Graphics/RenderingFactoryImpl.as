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
			var context : DisplayListContext = new DisplayListContext( container, width, height )

			/**
			 * WORKAROUND: In order to support the reduced color buffer resolution of 800x600 pixels a global scale transformation is applied.
			 */
			if( width === 800 &&
				height === 600 ) {

				var scaleFactor : Number = 800 / 1024

				context.scale( [ scaleFactor, scaleFactor, 1.0 ] )
				context.save()
			}

			return context
		}
	}
}
