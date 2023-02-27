import 'package:encs_chat/components/my_dialog.dart';
import 'package:encs_chat/validation/reg_exp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Receive an email to reset your pass.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email != null && !emailValid.hasMatch(email) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.email_outlined),
              label: const Text(
                'Reset Password',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: resetPassword,
            ),
          ],
        ),
      ),
    ),
  );
  
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
    }
    on FirebaseAuthException catch (ex) {
      showDialog(
        context: context,
        builder: (context) => MyDialog(text: ex.code),
      );
    }
  }
}
