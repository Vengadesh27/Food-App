import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   child: TextField(
          //     // controller: emailController,
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       labelText: 'Email'
          //     ),
          //   ),
          // ),

        ],
      ),

    );
  }
}