import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // Module 3
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4



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
    // Module 4
    // Wrap your app with ProviderScope at the root level to initialize Riverpod. 
    ProviderScope(
      child: MyApp(),
    ),
  );
}



// Class MyApp ===> Root of the application 
class MyApp extends StatelessWidget {  // Stateless = immutable = can't change
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Real-Time Collab App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Real-Time Collab App'),
    );
  }
}



// Class MyHomePage ===> Main Screen of the application (handles title, creates instance of _MyHomePageState to manage state)
class MyHomePage extends StatefulWidget {   // Stateful = mutable = can change ; has seperat estate class (_MyHomePageState)
  const MyHomePage({super.key, required this.title});
  final String title; // Allows for title of app

  @override 
  State<MyHomePage> createState() => _MyHomePageState(); // Creates instance of _MyHomePageState
                                                         // Tells dart that the build is being redefined by another method 
}



// Class _MyHomePageState ===> User Interface for homescreen of application (styles look and function of home page)
class _MyHomePageState extends State<MyHomePage> { // extends MyHomePage which extends StaefulWidget



  // Module 3 - defines channel connection and TextEditingController for listeners to receive text field updates
  final TextEditingController _controller = TextEditingController(); 



  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), 
      ),
      body: 
      Center( 
        child: 
          Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              const Text('Welcome to the Real-Time Collaboration Module'), 
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(8.0), 

                  // Module 3 - Box for user to enter data
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Send a message'),
                  ),
                ),
              ),



              // Module 3 - StreamBuilder listens for new messages and displays them
                          // Creates text box for data to be displayed; connects to stream and asks
                          // flutter to rebuild every time it receives an event using the builder() function

              const SizedBox(height: 24),
              // Using Consumer to watch chatMessagesProvider
              Consumer(
                builder: (context, ref, child) {
                  final chatState = ref.watch(chatMessagesProvider);

                  return chatState.when(
                    data: (message) {
                      // Display incoming chat message (plain text)
                      return Text(message); // Display the received message
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
            ],
          ),
        ),



      // Module 3 - Displays button for user to send data
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () {
              final webSocketService = ref.read(webSocketServiceProvider); 
              final message = _controller.text;
              if (message.isNotEmpty) {
                webSocketService.sendMessage(message);
                _controller.clear();
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


