// ignore: file_names
import 'package:flutter/material.dart';
import 'package:patient_manager/Authentication/authCheck.dart';
import 'package:patient_manager/components/signInOrRegister.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:patient_manager/pages/patientManager.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AuthCheck());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/patient-manager':
        return MaterialPageRoute(builder: (_) => const PatientManager());
      case '/signin':
        return MaterialPageRoute(builder: (_) => const SignInOrRegister());
      // //case '/signIn':
      // //  return MaterialPageRoute(builder: (_) => SignIn());
      // case '/auth':
      //   return MaterialPageRoute(builder: (_) => const AuthPage());
    }
    throw '';
  }
}
