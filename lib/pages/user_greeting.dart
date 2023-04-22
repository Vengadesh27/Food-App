import 'package:flutter/material.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Index 0: Donations',
      style: optionStyle,
    );
  }
}
