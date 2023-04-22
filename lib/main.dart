import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_donation/auth/auth_page.dart';
import 'package:food_donation/auth/utils.dart';
import 'package:food_donation/screens/admin_home_screen.dart';
import 'package:food_donation/screens/recipient_home_screen.dart';
import 'package:food_donation/screens/donor_home_screen.dart';

// void main() => runApp(const MyApp());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Food Donation';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text(_title)),
        ),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went Wrong!'));
            } else if (snapshot.hasData && snapshot.data != null) {
                return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final user = snapshot.data!.data() as Map<String,dynamic>;
                    if (user['role'] == 'admin') {
                      return const AdminHomeScreen();
                    } else if (user['role'] == 'donor') {
                      return const DonorHomeScreen();
                    } else if (user['role'] == 'recipient') {
                      return const RecipientHomeScreen();
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}
