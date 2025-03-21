import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:web_socket_channel/status.dart' as status;

class ChatServer {
  final List<WebSocket> _clients = [];

  void start(String host, int port) async {
    final server = await HttpServer.bind('0.0.0.0', 8000);

    await for (var request in server) {
      if (request.uri.path == '/chat') {
        try {
          WebSocketTransformer.upgrade(request).then((WebSocket webSocket) {
            _clients.add(webSocket);
            _handleClient(webSocket);
          });
        } catch (e) {
          request.response.statusCode = HttpStatus.internalServerError;
          await request.response.close();
        }
      } else {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    }
  }

  void _handleClient(WebSocket client) {
    client.listen(
      (message) {
        _broadcastMessage(message, client);
      },
      onDone: () {
        _clients.remove(client);
      },
      onError: (error) {
        _clients.remove(client);
      },
    );
  }

  void _broadcastMessage(String message, WebSocket sender) {
    for (var client in _clients) {
      if (client != sender) {
        client.add(message);
      }
    }
  }
}






class WebSocketService {
  WebSocketChannel? _channel;
  final String url;
  final StreamController<String> _messageController = StreamController.broadcast();
  final StreamController<String> _errorController = StreamController.broadcast();

  WebSocketService(this.url) {
    _connect();
  }

  void _connect() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (data) {
          _messageController.add(data.toString());
        },
        onError: (error) {
          _errorController.add("WebSocket Error: $error");
          _attemptReconnect();
        },
        onDone: () {
          _errorController.add("WebSocket Connection Closed");
          _attemptReconnect();
        },
        cancelOnError: true,
      );
    } catch (e) {
      _errorController.add("Connection failed: $e");
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    Future.delayed(Duration(seconds: 3), () {
      print("Attempting to reconnect...");
      _connect();
    });
  }

  Stream<String> get messageStream => _messageController.stream;
  Stream<String> get errorStream => _errorController.stream;

  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
    _messageController.close();
    _errorController.close();
  }
}







final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService("ws://127.0.0.1:8000/chat");
});

final chatMessagesProvider = StreamProvider<String>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  ref.onDispose(() => webSocketService.dispose());
  return webSocketService.messageStream;
});

final webSocketErrorProvider = StreamProvider<String>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.errorStream;
});