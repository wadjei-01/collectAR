import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navbar/auth/login/login_page.dart';
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootPage extends StatefulWidget {
  RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const NavBar();
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
