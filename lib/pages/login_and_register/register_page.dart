import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_dialog.dart';
import '../../components/my_textfield.dart';
import '../../components/square_tile.dart';
import '../../validation/reg_exp.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign up user with e-mail and password
  Future signUpUser() async {
    // Try creating user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    on FirebaseAuthException catch (ex) {
      // Show error message
      if (ex.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (context) => const MyDialog(text: 'Podany adres e-mail znajduje się już w bazie!'),
        );
      }
      else {
        showDialog(
          context: context,
          builder: (context) => MyDialog(text: ex.code),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Dismiss the keyboard when touched outside
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // Avoid error => Bottom overflowed by x pixels when showing keyboard
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Form(
            key: _signUpKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo
                    const Icon(
                      Icons.mail_lock,
                      size: 100,
                    ),

                    const SizedBox(height: 40),

                    // Create account text
                    Text(
                      'Utwórz nowe konto!',
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
                          return 'Niepoprawy format adresu e-mail!';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Hasło',
                      obscureText: true,
                      validator: (inputVal) {
                        if (inputVal.toString().isEmpty) {
                          return 'Proszę wprowadzić hasło!';
                        }
                        else if (inputVal.toString().length < 8) {
                          return 'Hasło powinno zawierać minimum 8 znaków!';
                        }
                        else if (!inputVal.toString().contains(passOneUpperCase)) {
                          return 'Hasło powinno zawierać dużą literę!';
                        }
                        else if (!inputVal.toString().contains(passOneLowerCase)) {
                          return 'Hasło powinno zawierać małą literę!';
                        }
                        else if (!inputVal.toString().contains(passOneDigit)) {
                          return 'Hasło powinno zawierać cyfrę!';
                        }
                        else if (!inputVal.toString().contains(passOneSpecialCharacter)) {
                          return 'Hasło powinno zawierać znak specjalny!';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Confirm password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Powtórz hasło',
                      obscureText: true,
                      validator: (inputVal) {
                        if (inputVal.toString().isEmpty) {
                          return 'Proszę potwierdzić hasło!';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // Sign up button
                    MyButton(
                      onTap: () async {
                        if (!_signUpKey.currentState!.validate()) {
                          debugPrint('Registration not validated!');
                        }
                        else if (
                          _signUpKey.currentState!.validate() &&
                            passwordController.text != confirmPasswordController.text) {
                          showDialog(
                            context: context,
                            builder: (context) => const MyDialog(text: 'Hasła nie są takie same!'),
                          );
                        }
                        else {
                          debugPrint('Registration validated!');
                          await signUpUser();
                        }
                      },
                      text: 'Zarejestruj się',
                    ),

                    const SizedBox(height: 40),

                    // Or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'lub kontynuuj za pomocą',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Google and Apple sign up buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        // Google button
                        SquareTile(imagePath: 'lib/images/google.png'),

                        SizedBox(width: 25),

                        // Apple button
                        SquareTile(imagePath: 'lib/images/apple.png'),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Already have an account? Log in!
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Masz już konto?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Zaloguj się!',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
}