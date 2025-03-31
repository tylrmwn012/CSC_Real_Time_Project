import 'package:flutter/material.dart'; // Module 2
import '../Web Socket/contacts.dart' as my_home_page;


// Now this is the main screen (formerly SecondScreen)
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      backgroundColor: Colors.grey[200],   
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Real-Time Collab'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            const Text("Welcome to Real-Time Collab!"),
            const Text("Please enter your name to continue..."),

            // Username
            TextField(
                  obscureText: false,
                  decoration: InputDecoration(labelText: 'Name'),
                ),

             SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => my_home_page.MyHomePage(title: title)),
                    );
                  },
                  child: const Text('Continue'), 
                ),
              ),
          ],
        ),
      ),
    );
  }
}
