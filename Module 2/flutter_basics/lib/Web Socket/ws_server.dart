import 'package:web_socket_channel/web_socket_channel.dart'; // Module 3
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'dart:async';
import 'package:web_socket_channel/status.dart' as status;



// WebSocket Service with Error Handling
class WebSocketService {
  final WebSocketChannel _channel;
  final StreamController<String> _messageController = StreamController.broadcast();
  final StreamController<String> _errorController = StreamController.broadcast();

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url)) {
    _channel.stream.listen(
      (data) {
        _messageController.add(data.toString());
      },
      onError: (error) {
        _errorController.add("WebSocket Error: $error");
      },
      onDone: () {
        _errorController.add("WebSocket Connection Closed");
      },
      cancelOnError: true,
    );
  }

  Stream<String> get messageStream => _messageController.stream;
  Stream<String> get errorStream => _errorController.stream;

  void sendMessage(String message) {
    try {
      _channel.sink.add(message);
    } catch (e) {
      _errorController.add("Failed to send message: $e");
    }
  }

  void dispose() {
    _channel.sink.close(status.goingAway);
    _messageController.close();
    _errorController.close();
  }
}

// WebSocket Service Provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService("wss://echo.websocket.events");
});

// StreamProvider for chat messages
final chatMessagesProvider = StreamProvider<String>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  ref.onDispose(() => webSocketService.dispose());
  return webSocketService.messageStream;
});

// StreamProvider for WebSocket errors
final webSocketErrorProvider = StreamProvider<String>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.errorStream;
});
