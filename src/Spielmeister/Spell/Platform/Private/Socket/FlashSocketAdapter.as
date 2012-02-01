package Spielmeister.Spell.Platform.Private.Socket {

	public class FlashSocketAdapter implements IWebSocketLogger {
		static protected var index: int = -1
		protected var newSocket : WebSocket

		public function FlashSocketAdapter( path : String ) {
			var query = ""
			newSocket = new WebSocket(++index, "ws://127.0.0.1:8080" + path + "/1/websocket/183198701832975559" + query, [], "http://127.0.0.1:8080", null, 0, "", null, this);

			newSocket.addEventListener("error", function(e) {
				trace(e)
			});


		}
		public function log(message:String):void {
	  trace(message)
	}

	 public function error(message:String):void {
	  trace(">>>>>>>>>>>>ERROR")
	  trace(message)
	 }

		public function on( messageName : String, callback : Function ) : void {

			if (messageName == 'connection') {
				newSocket.addEventListener("open", callback);

			} else if (messageName =='message') {
				newSocket.addEventListener("message", callback);

			} else if (messageName == 'disconnect') {
				newSocket.addEventListener("close", callback);
			}

		   //	newSocket.addEventListener("error", onSocketEvent);
		}
	}
}
