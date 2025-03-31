import 'package:flutter/material.dart'; // Module 2
import 'Authentication/authentication.dart' as log_in;

// Class MyApp ===> Root of the application 
class MyApp extends StatelessWidget {  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Real-Time Collab App',
theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.light)),

      home: const log_in.MyHomePage(title: 'Real-Time Collab'),
    );
  }
}