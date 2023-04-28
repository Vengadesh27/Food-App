import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/main.dart';
import 'package:email_validator/email_validator.dart';
import 'utils.dart';

class SigninScreen extends StatefulWidget {
  final Function() onClickedLogIn;
  const SigninScreen({super.key, required this.onClickedLogIn});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final fnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // String dropDownValue = 'donor';
  // var items = ['donor', 'recipient'];

  static List<String> items = <String>['donor', 'recipient'];
  String dropDownValue = items.first;
  static final RegExp nameRegExp = RegExp('[a-zA-Z]');

  Future<void> saveSignUpData(
      String fname, String email,String role, String uid) async {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'Email': email,
          'Fname': fname,
          'role': role,
        });
      }

  @override
  void dispose() {
    fnameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  "SignUp Screen",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                    controller: fnameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.isEmpty
                        ? 'Enter your name'
                        : (nameRegExp.hasMatch(value))
                            ? null
                            : 'Enter a valid name'),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
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
                  textInputAction: TextInputAction.next,
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
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField<String>(
                  value: dropDownValue,
                  decoration: const InputDecoration(
                      labelText: 'Select Role', border: OutlineInputBorder()),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropDownValue = value!;
                    });
                  },
                  validator: (value) => value == null ? 'field required' : null,
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  onPressed: signUp,
                  child: const Text('Sign Up'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: widget.onClickedLogIn,
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
          saveSignUpData(fnameController.text,emailController.text.trim(),dropDownValue,userCred.user!.uid);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    //Navigator.of(Context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
