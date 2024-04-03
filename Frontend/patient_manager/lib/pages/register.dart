import 'package:flutter/material.dart';
import 'package:patient_manager/components/myTextField.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
      emailController.clear();
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
                  'Register',
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
                    obscureText: false,
                  ),
                ),
                //spacer
                const SizedBox(height: 25),
                //password input
                SizedBox(
                  width: 500.0,
                  child: MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                ),
                //spacer
                const SizedBox(height: 10),
                // forgot password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                //spacer
                const SizedBox(height: 50),
                // sign in button
                SizedBox(
                  width: 500.0,
                  child: MyButton(
                    onTap: signUserIn,
                    buttonText: "Sign Up",
                  ),
                ),
                //spacer
                const SizedBox(height: 30),
                //register text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already a User?',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign In',
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
