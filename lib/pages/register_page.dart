import 'package:encs_chat/components/my_button.dart';
import 'package:encs_chat/components/my_textfield.dart';
import 'package:encs_chat/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign up user with e-mail and password
  void signUpUser() async {
    // Try creating user
    try {
      // Check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      }
      else {
        // Passwords don't match - show error message
        showErrorMessage('Hasła nie są takie same!');
      }
    }
    on FirebaseAuthException catch (ex) {
      // Show error message
      showErrorMessage(ex.code);
    }
  }

  // Error message to user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(), // Dismiss the keyboard when touched outside
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // Avoid error => Bottom overflowed by x pixels when showing keyboard
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
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

                  // Username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Adres e-mail',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Hasło',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // Confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Powtórz hasło',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // Sign up button
                  MyButton(
                    onTap: signUpUser,
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

                  // Google and Apple sign in buttons
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

                  // Not a member? Register now!
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
            ),
          ),
        ),
      ),
    );
  }
}
