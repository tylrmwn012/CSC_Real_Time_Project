import 'package:flutter/material.dart'; // Module 2
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Module 4
import 'my_app.dart' as my_app;



void main() { // Runs MyApp() 
  runApp(
    ProviderScope(
      child: my_app.MyApp(),
    ),
  );
}
