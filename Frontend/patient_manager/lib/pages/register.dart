import 'package:flutter/material.dart';
import 'package:patient_manager/components/myPassInput.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/theme/mihTheme.dart';
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
  final confirmPasswordController = TextEditingController();
  final officeID = TextEditingController();

  bool _obscureText = true;
  //sign user in
  Future<void> signUserUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      loginError("Passwords do not match");
    } else {
      try {
        final response = await client.auth.signUp(
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
        confirmPasswordController.clear();
      }
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

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: MyTheme().secondaryColor(),
                ),
                //spacer
                const SizedBox(height: 10),
                //Heading
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MyTheme().secondaryColor(),
                  ),
                ),
                //spacer
                const SizedBox(height: 25),
                //email input
                SizedBox(
                  width: 500.0,
                  child: MyTextField(
                    controller: officeID,
                    hintText: 'OfficeID',
                    editable: true,
                    required: true,
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
                const SizedBox(height: 25),
                //password input
                SizedBox(
                  width: 500.0,
                  child: MyPassField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    required: true,
                  ),
                ),
                //spacer
                const SizedBox(height: 10),
                // sign up button
                SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: MyButton(
                    onTap: () {},
                    buttonText: "Sign Up",
                    buttonColor: MyTheme().secondaryColor(),
                    textColor: MyTheme().primaryColor(),
                  ),
                ),
                //register text
                SizedBox(
                  width: 450.0,
                  height: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18,
                            color: MyTheme().secondaryColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
