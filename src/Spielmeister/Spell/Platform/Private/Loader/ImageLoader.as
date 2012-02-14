package Spielmeister.Spell.Platform.Private.Loader {

	import Spielmeister.Spell.Platform.Private.Loader.Loader

	import flash.display.Bitmap
	import flash.display.Loader
	import flash.events.Event
	import flash.net.URLRequest


	public class ImageLoader implements Spielmeister.Spell.Platform.Private.Loader.Loader {
		private var serverHostPort : String
		private var eventManager : Object
		private var resourceBundleName : String
		private var resourceUri : String
		private var onCompleteCallback : Function
		private var loader : flash.display.Loader


		public function ImageLoader( serverHostPort : String, eventManager : Object, resourceBundleName : String, resourceUri : String, callback : Function ) {
			this.serverHostPort     = serverHostPort
			this.eventManager       = eventManager
			this.resourceBundleName = resourceBundleName
			this.resourceUri        = resourceUri
			this.onCompleteCallback = callback
		}

		public function start() : void {
			loader = new flash.display.Loader()
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoad )

			var uri : String = 'http://' + serverHostPort + '/' + resourceUri
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
