import 'package:flutter/material.dart';
import 'package:flutter_transactions/screens/auth/login.dart';
import 'package:flutter_transactions/screens/auth/register.dart';
import 'package:flutter_transactions/screens/categories/categories_list.dart';

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
        '/categories': (context) => CategoriesList(),
      },
    );
  }
}
