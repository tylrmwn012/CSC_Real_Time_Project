import 'package:flutter/material.dart'; // Module 2
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'web_socket_server.dart';


// Class MyHomePage ===> Main Screen of the application 
class MyHomePage extends StatefulWidget {   
  const MyHomePage({super.key, required this.title});
  final String title;

  @override 
  State<MyHomePage> createState() => _MyHomePageState(); 
}








class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Real-Time Collab: Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            SizedBox(
        height: 100.0,
        width: 500,
        child: SizedBox(
          child: FloatingActionButton( 
            onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Web-Socket Contact'),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}









class _MyHomePageState extends State<MyHomePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final List<String> _times = [];


  // function to handle sending of message
  void _sendMessage(WidgetRef ref) {
    final webSocketService = ref.read(webSocketServiceProvider);
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      final formattedMessage = "You: $message";
      webSocketService.sendMessage(message);
      _controller.clear();
      _messages.insert(0, formattedMessage);
      _times.insert(0, DateFormat('jms').format(DateTime.now()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type a message to continue..."),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            FloatingActionButton(
              onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondScreen()),
                      );
                    },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            Consumer(
              builder: (context, ref, child) {
                final chatState = ref.watch(chatMessagesProvider);

                return chatState.when(
                  data: (message) {
                    final formattedMessage = message.startsWith("You: ")
                        ? message
                        : "Sender: $message";

                    _messages.insert(0, formattedMessage);
                    _times.insert(0, DateFormat('jms').format(DateTime.now()));

                    return Expanded(
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notUserMessage = _messages[index].startsWith("Sender: ");

                          return Align(
                            alignment: notUserMessage ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
            ),
            // handles message input and sending
            Form(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          autofocus: true,
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Send a message',
                          ),
                          maxLines: 3,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          return Row(
                            children: [
                              // handles button sending
                              FilledButton(
                                onPressed: () => _sendMessage(ref),
                                child: const Icon(Icons.send),
                              ),
                              // handles return key sending
                              KeyboardListener(
                                focusNode: _focusNode,
                                onKeyEvent: (event) {
                                  if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                                    _sendMessage(ref);
                                  }
                                },
                                child: const SizedBox(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      backgroundColor: Colors.grey[250],
    );
  }
}



