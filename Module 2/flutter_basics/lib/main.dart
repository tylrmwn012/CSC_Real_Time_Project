import 'package:flutter/material.dart'; // Module 2
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'my_home_page.dart' as my_home_page;

void main() { // Runs MyApp() 
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}



// Class MyApp ===> Root of the application 
class MyApp extends StatelessWidget {  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Real-Time Collab App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const my_home_page.MyHomePage(title: 'Real-Time Collab App'),
    );
  }
}
