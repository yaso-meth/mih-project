import 'package:flutter/material.dart';
import 'package:patient_manager/components/signInOrRegister.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange.distinct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data?.session;
          if (user == null) {
            // User not authenticated, show login screen
            return const SignInOrRegister();
            //Navigator.of(context).pushNamed('/signin');
          } else {
            // User authenticated, show home screen
            return const Home();
            //Navigator.of(context).pushNamed('/homme');
          }
        }

        // Connection state not active, show loading indicator
        return const CircularProgressIndicator();
      },
    );
  }
}
