import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
            decoration:const BoxDecoration(
              image:DecorationImage(
                image: AssetImage('assets/food_donation_logo.png'),
                fit: BoxFit.cover
              )
            )
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email'
              ),
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
              child: const Text('Log In'),
              onPressed: (){
                print(emailController.text);
                print(passwordController.text);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Don\'t have an account?'),
              TextButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: (){
                  //signup screen
                },
              )
            ],
          ),
          TextButton(
            onPressed: (){
              //forgot password screen
            },
            child: const Text('Forgot Password',),
          ),
        ],
      ),
    );
  }
}