import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart'; // Module 3

void main() { // Runs MyApp() 
  runApp(const MyApp());
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
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );


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
              StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),
            ],
          ),
        ),


      // Module 3 - Displays button for user to send data; calls _sendMessage when pressed
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }


  // Module 3 - sends the data (message) to the server
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }


  // Module 3 - closes the websocket connection
  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
