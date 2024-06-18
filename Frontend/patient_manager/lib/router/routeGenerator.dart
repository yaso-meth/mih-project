// ignore: file_names
import 'package:flutter/material.dart';
import 'package:patient_manager/Authentication/authCheck.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/signInOrRegister.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:patient_manager/pages/patientManager.dart';
import 'package:patient_manager/pages/patientView.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthCheck());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/patient-manager':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => PatientManager(
              userEmail: args,
            ),
          );
        }
        return _errorRoute();
      case '/patient-manager/patient':
        if (args is Patient) {
          return MaterialPageRoute(
            builder: (_) => PatientView(
              selectedPatient: args,
            ),
          );
        }
        return _errorRoute();
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

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return const Scaffold(
      appBar: MyAppBar(barTitle: "Error"),
      body: Center(
        child: Text("Error"),
      ),
    );
  });
}
