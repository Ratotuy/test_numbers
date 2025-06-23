import 'package:flutter/material.dart';
import 'package:numbers_test/screens/home_page.dart';
import 'package:numbers_test/screens/saved_screen.dart';


void main() {
  runApp(NumberInfoApp());
}

class NumberInfoApp extends StatelessWidget {
  const NumberInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/saved': (context) => SavedScreen(),
      },
    );
  }
}
