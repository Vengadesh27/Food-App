import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_donation/auth/utils.dart';
import 'package:food_donation/main.dart';
import 'package:email_validator/email_validator.dart';

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
          Container(
              height: 250.0,
              width: 250.0,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/food_donation_logo.png'),
                      fit: BoxFit.cover))),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) => value != null && value.length < 6
                      ? 'Enter minimum 6 characters'
                      : null),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: widget.onClickedSignUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20),
                ),
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
          ),
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
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

// Container(
          //   padding: const EdgeInsets.all(15),
          //   child: RichText(
          //     text: TextSpan(
          //         style: const TextStyle(color: Colors.black, fontSize: 18),
          //         text: 'Don\'t have an account? ',
          //         children: [
          //           TextSpan(
          //               recognizer: TapGestureRecognizer()
          //                 ..onTap = widget.onClickedSignUp,
          //               text: 'Sign Up',
          //               style: TextStyle(
          //                   color: Theme.of(context).colorScheme.secondary,
          //                   fontWeight: FontWeight.bold)),
          //         ]),
          //     textAlign: TextAlign.center,
          //   ),
          // )