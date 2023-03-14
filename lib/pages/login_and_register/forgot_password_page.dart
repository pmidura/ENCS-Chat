import 'package:encs_chat/components/login_and_register/my_button.dart';
import 'package:encs_chat/components/login_and_register/my_ftoast.dart';
import 'package:encs_chat/components/login_and_register/my_textfield.dart';
import 'package:encs_chat/validation/reg_exp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _resetPassKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        showMyFToast('Link do resetowania hasła został przesłany na podany adres e-mail.');
      }
    }
    on FirebaseAuthException catch (ex) {
      // Show error message
      if (ex.code == 'user-not-found') {
        showMyFToast('Nie znaleziono użytkownika o podanym adresie e-mail!');
      }
      else {
        showMyFToast(ex.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Dismiss the keyboard when touched outside
    child: Scaffold(
      // resizeToAvoidBottomInset: false, // Avoid error => Bottom overflowed by x pixels when showing keyboard
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Form(
          key: _resetPassKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              const Icon(
                Icons.mail_lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // Forgot password? - Text
              Text(
                'Zapomniałeś hasła? Zresetuj je już teraz!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // E-mail textfield
              MyTextField(
                controller: emailController,
                hintText: 'Adres e-mail',
                obscureText: false,
                validator: (inputVal) {
                  if (inputVal.toString().isEmpty) {
                    return 'Proszę wprowadzić adres e-mail!';
                  }
                  else if (!emailValid.hasMatch(inputVal.toString())) {
                    return 'Niepoprawny format adresu e-mail!';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              // Reset password button
              MyButton(
                onTap: () async {
                  if (!_resetPassKey.currentState!.validate()) {
                    debugPrint('Reset password not validated!');
                  }
                  else {
                    debugPrint('Reset password validated!');
                    await resetPassword();
                  }
                },
                text: 'Resetuj hasło',
              ),

              const SizedBox(height: 25),

              // Back to login page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Text(
                      'Powrót do logowania',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
