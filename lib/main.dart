import 'package:flutter/material.dart';
import 'package:flutter_transactions/screens/auth/Login.dart';
import 'package:flutter_transactions/screens/auth/Register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    );
  }
}
