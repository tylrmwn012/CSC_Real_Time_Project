import 'package:flutter/material.dart'; // Module 2
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'package:intl/intl.dart';
import 'one_web.dart';


class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}


class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  // function to handle sending of message
  void _sendMessage() {
    final webSocketService = ref.read(webSocketServiceProvider);
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
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
    final webSocketService = ref.read(webSocketServiceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          // Message Display Area with StreamBuilder
          Expanded(
            child: StreamBuilder<String>(
              stream: webSocketService.messageStream, // Listening to WebSocket messages
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final messages = snapshot.data?.split('\n') ?? [];

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index].trim();
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
                );
              },
            ),
          ),

          // Message Input and Send Button
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
                    FilledButton(
                      onPressed: _sendMessage,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      backgroundColor: Colors.grey[250],
    );
  }
}