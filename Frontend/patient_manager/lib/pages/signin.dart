import 'package:flutter/material.dart';
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

  //sign user in
  Future<void> signUserIn() async {
    try {
      final response = await client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (response.session != null) {
        Navigator.of(context).pushNamed('/homme');
      }
    } on AuthException catch (error) {
      loginError(error.message);
      //emailController.clear();
      passwordController.clear();
    }
  }

  void loginError(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                //spacer
                const SizedBox(height: 10),
                //Heading
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
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
                  ),
                ),
                //spacer
                const SizedBox(height: 10),
                // sign in button
                SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: MyButton(
                    onTap: signUserIn,
                    buttonText: "Sign In",
                  ),
                ),
                //spacer
                const SizedBox(height: 30),
                //register text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New User?',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
