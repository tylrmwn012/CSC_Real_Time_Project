import 'package:flutter/material.dart';

void main() { // Runs MyApp() 
  runApp(const MyApp());
}


// Class MyApp ===> Root of the application 
class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Real-Time Collab App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Real-Time Collab App'),
    );
  }
}


// Class MyHomePage ===> Main Screen of the application (handles title, creates instance of _MyHomePageState to manage state)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title; // Allows for title of app

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // Creates instance of _MyHomePageState
}


// Class _MyHomePageState ===> User Interface for homescreen of application (styles look and function of home page)
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Return this scaffold
      appBar: AppBar( //open AppBar
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), 
      ),
      body: Center( // Open body's center section
        child: Column( // Open child of body, the Column section
          mainAxisAlignment: MainAxisAlignment.center, // Aligns the text at the center
          children: <Widget>[
            const Text('Welcome to the Real-Time Collaboration Module'), // Text to be display in the center
          ],
        ),
      ),
    );
  }
}
