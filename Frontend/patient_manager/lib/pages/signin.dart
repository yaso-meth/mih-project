import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/myPassInput.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignIn extends StatefulWidget {
  final Function()? onTap;
  const SignIn({super.key, required this.onTap});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //bool _obscureText = true;
  bool successfulSignIn = false;
  // focus node to capture keyboard events
  final FocusNode _focusNode = FocusNode();

  //sign user in
  Future<void> signUserIn() async {
    try {
      final response = await client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (response.session != null) {
        setState(() {
          successfulSignIn = true;
        });
        //Navigator.of(context).pushNamed('/homme');
      }
    } on AuthException {
      loginError();
      //emailController.clear();
      passwordController.clear();
    }
  }

  void loginError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Invalid Credentials");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return const MyErrorMessage(errorType: "Input Error");
              },
            );
          } else {
            signUserIn();
          }

          if (successfulSignIn) {
            Navigator.of(context).pushNamed('/homme');
          }
        }
      },
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Icon(
                    Icons.lock,
                    size: 100,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  //spacer
                  const SizedBox(height: 10),
                  //Heading
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                  //spacer
                  const SizedBox(height: 25),
                  //email input
                  SizedBox(
                    width: 500.0,
                    child: MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      editable: true,
                      required: true,
                    ),
                  ),
                  //spacer
                  const SizedBox(height: 25),
                  //password input
                  SizedBox(
                    width: 500.0,
                    child: MyPassField(
                      controller: passwordController,
                      hintText: 'Password',
                      required: true,
                    ),
                  ),
                  //spacer
                  const SizedBox(height: 10),
                  // sign in button
                  SizedBox(
                    width: 500.0,
                    height: 100.0,
                    child: MyButton(
                      buttonText: "Sign In",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      onTap: () {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MyErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        } else {
                          signUserIn();
                        }

                        if (successfulSignIn) {
                          Navigator.of(context).pushNamed('/homme');
                        }
                      },
                    ),
                  ),
                  //spacer
                  //const SizedBox(height: 30),
                  //register text
                  SizedBox(
                    width: 450.0,
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'New User?',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 201, 200, 200)),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Register Now',
                            style: TextStyle(
                              fontSize: 18,
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
