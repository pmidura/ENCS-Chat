import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_and_register/login_or_register_page.dart';
import 'verify_email_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasData) {
            return const VerifyEmailPage();
          }
          else if (snapshot.hasError) {
            return const Center(child: Text('Ups! Coś poszło nie tak!'));
          }
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
