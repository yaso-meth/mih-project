// ignore: file_names
import 'package:flutter/material.dart';
import 'package:patient_manager/Authentication/authCheck.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:patient_manager/pages/signin.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AuthCheck());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/signin':
        return MaterialPageRoute(builder: (_) => const SignIn());
      // //case '/signIn':
      // //  return MaterialPageRoute(builder: (_) => SignIn());
      // case '/auth':
      //   return MaterialPageRoute(builder: (_) => const AuthPage());
    }
    throw '';
  }
}
