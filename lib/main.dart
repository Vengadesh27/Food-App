import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Food Donation';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text(_title)),
        ),
        body: const LoginScreen(),
      ),
    );
  }
}