import 'package:encs_chat/sqlite/local_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/login_and_register/my_button.dart';
import '../../components/login_and_register/my_ftoast.dart';
import '../../components/login_and_register/my_textfield.dart';
import '../../components/login_and_register/square_tile.dart';
import '../../firebase/cloud_store_data_management.dart';
import '../../provider/google_sign_in.dart';
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

  final CloudStoreDataManagement _cloudStoreDataManagement = CloudStoreDataManagement();
  final LocalDb localDb = LocalDb();

  // Sign up user with e-mail and password
  Future signUpUser() async {
    // Try creating user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _cloudStoreDataManagement.registerNewUser(
        userName: emailController.text.split('@')[0].trim(),
        userEmail: emailController.text.trim(),
      );

      // Calling local db methods to initialize local db with required methods
      await localDb.createTableToStoreImportantData();
      final Map<String, dynamic> importantFetchedData = await _cloudStoreDataManagement.getTokenFromCloudStore(
        userMail: FirebaseAuth.instance.currentUser!.email.toString(),
      );

      await localDb.insertOrUpdateDataForThisAccount(
        userName: FirebaseAuth.instance.currentUser!.email.toString().split('@')[0],
        userMail: FirebaseAuth.instance.currentUser!.email.toString(),
        userToken: importantFetchedData['token'],
        userAccCreationDate: importantFetchedData['date'],
        userAccCreationTime: importantFetchedData['time'],
      );

      await localDb.createTableForUserActivity(
        tableName: FirebaseAuth.instance.currentUser!.email.toString().split('@')[0],
      );
    }
    on FirebaseAuthException catch (ex) {
      // Show error message
      if (ex.code == 'email-already-in-use') {
        showMyFToast('Podany adres e-mail znajduje się już w bazie!');
      }
      else {
        showMyFToast(ex.code);
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
                        else if (inputVal.toString() != passwordController.text.trim()) {
                          return 'Hasła nie są takie same!';
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
