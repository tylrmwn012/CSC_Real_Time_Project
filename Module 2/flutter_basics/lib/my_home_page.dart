import 'package:flutter/material.dart'; // Module 2
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'package:intl/intl.dart';
import 'web_socket_server.dart';


// Class MyHomePage ===> Main Screen of the application 
class MyHomePage extends StatefulWidget {   
  const MyHomePage({super.key, required this.title});
  final String title;

  @override 
  State<MyHomePage> createState() => _MyHomePageState(); 
}




class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final List<String> _times = [];
  final ScrollController _scrollController = ScrollController();

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
            Consumer(
              builder: (context, ref, child) {
                final chatState = ref.watch(chatMessagesProvider);

                return chatState.when(
                  data: (message) {
                    final formattedMessage = message.startsWith("You: ")
                        ? message
                        : "Sender: $message";

                    _messages.add(formattedMessage);
                    _times.add(DateFormat('jms').format(DateTime.now()));

                    return Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                        itemCount: _messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final notUserMessage = _messages[index].startsWith("Sender: ");

                          return Align(
                            alignment: notUserMessage ? Alignment.centerRight : Alignment.centerLeft,
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
            Form(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            return FloatingActionButton(
                              onPressed: () {
                                final webSocketService = ref.read(webSocketServiceProvider);
                                final message = _controller.text.trim();
                                if (message.isNotEmpty) {
                                  final formattedMessage = "You: $message";
                                  webSocketService.sendMessage(message);
                                  _controller.clear();
                                  _messages.add(formattedMessage);
                                  _times.add(DateFormat('jms').format(DateTime.now()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please type message to continue..."),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              child: const Icon(Icons.send),
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
