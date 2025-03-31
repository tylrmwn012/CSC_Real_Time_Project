import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../Web Socket/one_web.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = []; // List to store all messages

  @override
  void initState() {
    super.initState();
    final webSocketService = ref.read(webSocketServiceProvider);

    // Listen to WebSocket messages and update state
    webSocketService.messageStream.listen((newMessage) {
      setState(() {
        _messages.insert(0, newMessage); // Insert at the top for reverse display
      });
    });
  }

  // Function to handle sending messages
  void _sendMessage(WidgetRef ref) {
    final webSocketService = ref.read(webSocketServiceProvider);
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.insert(0, "You: $message"); // Store sent message in the list
      });
      webSocketService.sendMessage(message);
      _controller.clear();
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
        backgroundColor: Colors.blue[100],
        title: const Text('Chat Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            // Message Display Area
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  final notUserMessage = !message.startsWith("You: ");

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
                            message,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('jms').format(DateTime.now()),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
      backgroundColor: Colors.grey[200],
    );
  }
}
