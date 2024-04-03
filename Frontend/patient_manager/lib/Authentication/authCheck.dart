import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:patient_manager/pages/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange.distinct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data?.session;
          if (user == null) {
            // User not authenticated, show login screen
            return SignIn();
          } else {
            // User authenticated, show home screen
            return Home();
          }
        }

        // Connection state not active, show loading indicator
        return CircularProgressIndicator();
      },
    );
  }
}
