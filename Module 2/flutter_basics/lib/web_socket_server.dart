import 'package:web_socket_channel/web_socket_channel.dart'; // Module 3
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'dart:async';



// Module 3 - WebSocket Service (handles the WebSocket connection and communication)
class WebSocketService { 
  final WebSocketChannel _channel;

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<String> get messageStream {
    return _channel.stream.map((data) {
      return data.toString();
    });
  }

  // Module 3 - sendMessage
  void sendMessage(String message) {
    _channel.sink.add(message); 
  }

  // Module 3 - dispose
  void dispose() {
    _channel.sink.close();
  }
}


// Module 3 - WebSocket Service Provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService("wss://echo.websocket.events");
});


// Module 4 - StreamProvider
final chatMessagesProvider = StreamProvider<String>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);

  ref.onDispose(() => webSocketService.dispose());

  return webSocketService.messageStream;
});