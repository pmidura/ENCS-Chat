import 'package:encs_chat/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/login_and_register/my_button.dart';
import '../../components/login_and_register/my_dialog.dart';
import '../../components/login_and_register/my_textfield.dart';
import '../../components/login_and_register/square_tile.dart';
import '../../validation/reg_exp.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _signInKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in user with e-mail and password
  Future signInUser() async {
    // Try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    on FirebaseAuthException catch (ex) {
      // Show error message
      if (ex.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) => const MyDialog(
            text: 'Nie znaleziono użytkownika o podanym adresie e-mail!',
          ),
        );
      }
      else if (ex.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (context) => const MyDialog(
            text: 'Nieprawidłowe hasło dla użytkownika o podanym adresie e-mail!',
          ),
        );
      }
      else {
        showDialog(
          context: context,
          builder: (context) => MyDialog(
            text: ex.code,
          ),
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
            key: _signInKey,
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

                    const SizedBox(height: 50),

                    // Welcome text
                    Text(
                      'Witamy z powrotem, brakowało nam Ciebie!',
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

                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child: Text(
                              'Zapomniałeś hasła?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            )),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Sign in button
                    MyButton(
                      onTap: () async {
                        if (!_signInKey.currentState!.validate()) {
                          debugPrint('Login not validated!');
                        }
                        else {
                          debugPrint('Login validated!');
                          await signInUser();
                        }
                      },
                      text: 'Zaloguj się',
                    ),

                    const SizedBox(height: 50),

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

                    const SizedBox(height: 50),

                    // Google and Apple sign in buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google button
                        GestureDetector(
                          child: const SquareTile(imagePath: 'lib/images/google.png'),
                          onTap: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false,
                            );
                            provider.googleLogin();
                          },
                        ),

                        const SizedBox(width: 25),

                        // Apple button
                        GestureDetector(
                          child: const SquareTile(imagePath: 'lib/images/apple.png'),
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    // Not a member? Register now!
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nie masz konta?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Zarejestruj się!',
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
