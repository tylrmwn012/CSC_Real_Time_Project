import 'package:flutter/material.dart'; // Module 2
import 'package:web_socket_channel/web_socket_channel.dart'; // Module 3
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'package:intl/intl.dart';
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


void main() { // Runs MyApp() 
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}




// Class MyApp ===> Root of the application 
class MyApp extends StatelessWidget {  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Real-Time Collab App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Real-Time Collab App'),
    );
  }
}




// Class MyHomePage ===> Main Screen of the application 
class MyHomePage extends StatefulWidget {   
  const MyHomePage({super.key, required this.title});
  final String title;

  @override 
  State<MyHomePage> createState() => _MyHomePageState(); 
}


// Class _MyHomePageState ===> UI for home screen
class _MyHomePageState extends State<MyHomePage> { 
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final List<String> _times = [];




  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), 
      ),
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: <Widget>[
            const Text(''),
            const Text('Welcome to the Real-Time Collaboration Module'), 
            Form(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Send a message'),
                ),
              ),
            ),
            const SizedBox(height: 24),




            // Module 3/4 - Consumer listens for new messages and updates UI
            Consumer(
              builder: (context, ref, child) {
                final chatState = ref.watch(chatMessagesProvider);

                return chatState.when(
                  data: (message) {
                    // Only prepend "Sender: " if the message doesn't already have "You: "
                    final formattedMessage = message.startsWith("You: ") 
                        ? message                 // Keep your own messages as they are
                        : "Sender: $message";     // Mark incoming messages as "Sender: "

                    _messages.add(formattedMessage);
                    _times.add(DateFormat('jms').format(DateTime.now())); 

                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notUserMessage = _messages[index].startsWith("Sender: ");

                          return Align(
                            alignment: notUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: notUserMessage ? Colors.blue[100] : Colors.green[100],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _messages[index],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _times[index],
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                );
              },
            )
          ],
        ),
      ),


      

      // Floating Button for Sending Messages
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () {
              final webSocketService = ref.read(webSocketServiceProvider);
              final message = _controller.text.trim();
              if (message.isNotEmpty) { 
                final formattedMessage = "You: $message";  // Add "You: " only for outgoing messages
                webSocketService.sendMessage(message);     // Send original message (no "You: ")
                _controller.clear();
                _messages.add(formattedMessage);            // Display with "You: " in your UI
                _times.add(DateFormat('jms').format(DateTime.now()));
              }
            },
            tooltip: 'Send message',
            child: const Icon(Icons.send),
          );
        },
      ),
    );
  }
}

