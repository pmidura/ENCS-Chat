import 'package:encs_chat/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign out method when user is logged in with e-mail address and password
  void signOutUserWithEmailAndPassword() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              for (final providerProfile in user.providerData) {
                final provider = providerProfile.providerId;

                if (provider == 'google.com') {
                  final googleProvider = Provider.of<GoogleSignInProvider>(context, listen: false);
                  googleProvider.googleLogout();
                }
                else if (provider == 'password') {
                  signOutUserWithEmailAndPassword();
                }
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL ?? 'https://www.seekpng.com/png/full/428-4287240_no-avatar-user-circle-icon-png.png'),
            ),
            const SizedBox(height: 10),
            Text(
              'Name: ${user.displayName ?? user.email}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${user.email!}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}