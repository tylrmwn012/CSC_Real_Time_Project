import 'dart:io';

void main() async {
  // Start WebSocket server on localhost:8080
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print("WebSocket server running on ws://${server.address.host}:${server.port}");

  final clients = <WebSocket>{};

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      clients.add(socket);
      print("Client connected. Total clients: ${clients.length}");

      // Listen for messages from clients
      socket.listen(
        (message) {
          print("Received: $message");
          // Broadcast the message to all connected clients
          for (var client in clients) {
            if (client != socket) {
              client.add(message);
            }
          }
        },
        onDone: () {
          clients.remove(socket);
          print("Client disconnected. Total clients: ${clients.length}");
        },
        onError: (error) {
          print("WebSocket error: $error");
        },
      );
    } else {
      request.response.statusCode = HttpStatus.forbidden;
      await request.response.close();
    }
  }
}
