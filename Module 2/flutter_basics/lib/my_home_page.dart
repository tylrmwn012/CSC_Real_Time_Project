import 'package:flutter/material.dart'; // Module 2
import 'echo_conversation_screen.dart' as echo_conversation_screen;
import 'one_contact.dart' as one_contact;
import 'two_contact.dart' as two_contact;


// Now this is the main screen (formerly SecondScreen)
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


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
                  child: const Text('Web-Socket Contact'),
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
                      MaterialPageRoute(builder: (context) => const one_contact.ConversationScreen()),
                    );
                  },
                  child: const Text('One Contact'),
                ),
              ),


// two
              
              SizedBox(
                height: 100.0,
                width: 500,
                child: FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const two_contact.ConversationScreen()),
                    );
                  },
                  child: const Text('Two Contact'),
                ),
              ),
            

          ],
        ),
      ),
    );
  }
}
