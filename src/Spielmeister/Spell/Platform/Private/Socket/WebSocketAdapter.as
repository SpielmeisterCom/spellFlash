package Spielmeister.Spell.Platform.Private.Socket {

	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketErrorEvent
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage


	public class WebSocketAdapter {
		private var socket : WebSocket
		private var onMessageCallback : Function


		public function WebSocketAdapter( url : String, origin : String, protocol : String ) {
			trace( 'Creating socket...' )

			socket = new WebSocket( url, origin, protocol )
			socket.connect()


			socket.addEventListener(
				WebSocketEvent.OPEN,
				function( event : WebSocketEvent ) : void {
					trace( 'Socket opened connection.' )
				}
			)

			socket.addEventListener(
				WebSocketEvent.CLOSED,
				function( event : WebSocketEvent ) : void {
					trace( 'Socket closed connection.' )
				}
			)

			socket.addEventListener(
				WebSocketErrorEvent.CONNECTION_FAIL,
				function( event : WebSocketErrorEvent ) : void {
					trace( 'Error on socket: ' + event.text )
				}
			)

			socket.addEventListener(
				WebSocketEvent.MESSAGE,
				function( event : WebSocketEvent ) : void {
					if( event.message.type === WebSocketMessage.TYPE_UTF8 ) {
//						trace( "Got message: " + event.message.utf8Data )

						onMessageCallback( {
							data: event.message.utf8Data
						} )

					} else if( event.message.type === WebSocketMessage.TYPE_BINARY ) {
						trace( "Got binary message of length " + event.message.binaryData.length )
					}
				}
			)
		}

		public function send( message : String ) : void {
			socket.sendUTF( message )
		}

		public function set onmessage( callback : Function ) : void {
			onMessageCallback = callback
		}
	}
}
