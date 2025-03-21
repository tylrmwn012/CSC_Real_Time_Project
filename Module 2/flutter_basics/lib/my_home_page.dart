import 'package:flutter/material.dart'; // Module 2
import 'conversation_screen.dart' as conversation_screen;


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
                      MaterialPageRoute(builder: (context) => const conversation_screen.ConversationScreen()),
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
                  },
                  child: const Text('Two Contact'),
                ),
              ),


// two
              SizedBox(
                height: 100.0,
                width: 500,
                child: FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: () {
                  },
                  child: const Text('One Contact'),
                ),
              ),
            

          ],
        ),
      ),
    );
  }
}
