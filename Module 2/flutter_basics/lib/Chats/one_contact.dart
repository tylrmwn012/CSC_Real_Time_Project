import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../Web Socket/one_web.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String userId;
  const ConversationScreen({super.key, required this.userId});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}



class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    final webSocketService = ref.read(webSocketServiceProvider);

    // takes incoming messages and adds them to the list in the following format
    // at index 0
    webSocketService.messageStream.listen((newMessage) {
      final decodedMessage = jsonDecode(newMessage);
      final senderId = decodedMessage['senderId'];
      final text = decodedMessage['text'];

      setState(() {
        _messages.insert(0, "$senderId: $text");
      });
    });
  }

  void _sendMessage() {
    final webSocketService = ref.read(webSocketServiceProvider);
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      final formattedMessage = jsonEncode({
        "senderId": widget.userId,
        "text": message,
      });

      setState(() {
        _messages.insert(0, "${widget.userId}: $message");
      });

      webSocketService.sendMessage(formattedMessage);
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
        title: const Text('One Contact'),
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
                  // split index into a sender and message to see whether the user sent it or not
                  final message = _messages[index];
                  final sender = message.split(": ")[0];
                  final isUserMessage = sender == widget.userId;

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.green[100] : Colors.blue[100],
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


            // Message Input Field
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: _focusNode,
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Send a message',
                      ),
                      maxLines: 3,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) => _sendMessage(), // Handles "Enter" key on mobile
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


            // Handles keyboard "Enter" key press on desktop
            KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: (event) {
                if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                  _sendMessage();
                }
              },
              child: const SizedBox(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
