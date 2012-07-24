package Spielmeister.Spell.Platform.Private.Loader {

	import flash.display.Bitmap
	import flash.display.Loader
	import flash.events.Event
	import flash.net.URLRequest


	public class ImageLoader implements Spielmeister.Spell.Platform.Private.Loader.Loader {
		private var eventManager : Object
		private var host : String
		private var resourceBundleName : String
		private var resourceUri : String
		private var renderingContext : Object
		private var onCompleteCallback : Function
		private var loader : flash.display.Loader


		public function ImageLoader( eventManager : Object, host : String, resourceBundleName : String, resourceUri : String, callback : Function, renderingContext : Object ) {
			this.eventManager       = eventManager
			this.host               = host
			this.resourceBundleName = resourceBundleName
			this.resourceUri        = resourceUri
			this.renderingContext   = renderingContext
			this.onCompleteCallback = callback
		}

		public function start() : void {
			loader = new flash.display.Loader()
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoad )

			var url : String = host + '/' + resourceUri
			loader.load( new URLRequest( url ) )
		}

		private function onLoad( event : Event ) : void {
			var bmp : Bitmap = loader.content as Bitmap
			var resources : Object = new Object()
			resources[ resourceUri ] = this.renderingContext.createTexture( bmp.bitmapData )

			this.onCompleteCallback( resources )
		}
	}
}
