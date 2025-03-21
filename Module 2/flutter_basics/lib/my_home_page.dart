import 'package:flutter/material.dart'; // Module 2
import 'second_screen.dart' as second_screen;




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
            const SizedBox(height: 16.0),
            SizedBox(
              height: 100.0,
              width: 500,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const second_screen.SecondScreen()),
                  );
                },
                child: const Text('Web-Socket Contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
