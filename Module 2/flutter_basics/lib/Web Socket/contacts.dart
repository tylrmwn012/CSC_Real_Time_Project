import 'package:flutter/material.dart'; // Module 2
import '../Chats/echo_conversation_screen.dart' as echo_conversation_screen;
import '../Chats/one_contact.dart' as one_contact;


// Now this is the main screen (formerly SecondScreen)
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title, required this.userId});
  final String title;
  final String userId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(       
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Contacts (Servers)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            
// echo   
              
              SizedBox(
                height: 100.0,
                width: 500,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const echo_conversation_screen.ConversationScreen()),
                    );
                  },
                  child: const Text('Echo Contact'),
                ),
              ),
// one
              
              SizedBox(
                height: 100.0,
                width: 500,
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => one_contact.ConversationScreen(userId: userId)),
                    );
                  },
                  child: const Text('One Contact'),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}






        