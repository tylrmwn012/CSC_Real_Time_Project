import 'package:flutter/material.dart'; // Module 2
import 'my_home_page.dart' as my_home_page;

// Class MyApp ===> Root of the application 
class MyApp extends StatelessWidget {  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Real-Time Collab App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const my_home_page.MyHomePage(title: 'Real-Time Collab'),
    );
  }
}