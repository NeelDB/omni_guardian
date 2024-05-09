import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omni_guardian/pages/alarm/alarm.dart';
import 'package:omni_guardian/pages/gallery.dart';
import 'package:omni_guardian/pages/home/home.dart';
import 'package:omni_guardian/pages/login/login.dart';
import 'package:omni_guardian/pages/login/login_or_register.dart';
import 'package:omni_guardian/pages/profile/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    Home(),
    Alarm(),
    Gallery(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alarm'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_photo), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}