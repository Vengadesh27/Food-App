import 'package:flutter/material.dart';
import 'package:food_donation/auth/signin_screen.dart';
import 'package:food_donation/auth/login_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreen(onClickedSignUp: toggle)
      : SigninScreen(onClickedLogIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
