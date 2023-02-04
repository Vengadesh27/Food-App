import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_donation/auth/signin_screen.dart';
import 'package:food_donation/main.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginScreen({super.key, required this.onClickedSignUp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          // Container(
          //   alignment: Alignment.center,
          //   padding: const EdgeInsets.all(10),
          //   child: const Text(
          //     'Food Donation App',
          //     style: TextStyle(
          //       color: Colors.blue,
          //       fontWeight: FontWeight.w500,
          //       fontSize: 30
          //     ),
          //   ),
          // ),
          // Container(
          //   alignment: Alignment.center,
          //   padding: const EdgeInsets.all(10),
          //   child: const Text(
          //     'Sign In',
          //     style: TextStyle(
          //       fontSize: 20
          //     ),
          //   ),
          // ),
          Container(
              height: 250.0,
              width: 250.0,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/food_donation_logo.png'),
                      fit: BoxFit.cover))),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              onPressed: logIn,
              child: const Text('Log In'),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(15),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  text: 'Don\'t have an account? ',
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Sign Up',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold)),
                  ]),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Future logIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}


/*
Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Don\'t have an account?'),
              TextButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    widget.onClickedSignUp;
                  });
                  //signup screen
                  
                },
              )
            ],
          ),
          TextButton(
            onPressed: () {
              //forgot password screen
            },
            child: const Text(
              'Forgot Password',
            ),
          ), */