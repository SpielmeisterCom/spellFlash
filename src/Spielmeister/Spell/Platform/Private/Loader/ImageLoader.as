package Spielmeister.Spell.Platform.Private.Loader {

	import Spielmeister.Spell.Platform.Private.Loader.Loader

	import flash.display.Bitmap
	import flash.display.Loader
	import flash.events.Event
	import flash.net.URLRequest


	public class ImageLoader implements Spielmeister.Spell.Platform.Private.Loader.Loader {
		private var eventManager : Object
		private var resourceBundleName : String
		private var resourceUri : String
		private var onCompleteCallback : Function
		private var loader : flash.display.Loader

		public function ImageLoader( eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) {
			this.eventManager       = eventManager
			this.resourceBundleName = resourceBundleName
			this.resourceUri        = resourceUri
			this.onCompleteCallback = callback
		}

		public function start() : void {
			loader = new flash.display.Loader()
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoad )

			// TODO: access to hostname:port must be abstracted
			var uri = 'http://localhost:8080/' + resourceUri
			loader.load( new URLRequest( uri ) )
		}

		private function onLoad( event : Event ) : void {
			var bmp : Bitmap = loader.content as Bitmap
			var resources : Object = new Object()
			resources[ resourceUri ] = bmp.bitmapData

			this.onCompleteCallback( resources )
		}
	}
}
