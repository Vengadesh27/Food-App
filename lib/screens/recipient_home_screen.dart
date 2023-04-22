import 'package:flutter/material.dart';
import '../pages/donations.dart';
import '../pages/profile.dart';

class RecipientHomeScreen extends StatefulWidget {
  const RecipientHomeScreen({super.key});

  @override
  State<RecipientHomeScreen> createState() => _RecipientHomeScreenState();
}

class _RecipientHomeScreenState extends State<RecipientHomeScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> pages = <Widget>[
    Text(
      'Welcome recipient',
      style: optionStyle,
    ),
    DonationPage(),
    ProfilePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
