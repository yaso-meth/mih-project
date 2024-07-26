import 'package:flutter/material.dart';
import 'package:patient_manager/Authentication/authCheck.dart';
import 'package:patient_manager/components/addOrViewPatient.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/signInOrRegister.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:patient_manager/pages/patientAdd.dart';
import 'package:patient_manager/pages/patientEdit.dart';
import 'package:patient_manager/pages/patientManager.dart';
import 'package:patient_manager/pages/patientView.dart';
import 'package:patient_manager/pages/profileUpdate.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthCheck());

      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/patient-profile':
        if (args is AppUser) {
          //print("route generator: $args");
          return MaterialPageRoute(
            builder: (_) => AddOrViewPatient(
              signedInUser: args,
            ),
          );
        }
        return _errorRoute();

      case '/patient-manager':
        if (args is String) {
          //print("route generator: $args");
          return MaterialPageRoute(
            builder: (_) => PatientManager(
              userEmail: args,
            ),
          );
        }
        return _errorRoute();

      case '/patient-manager/add':
        if (args is AppUser) {
          return MaterialPageRoute(
            builder: (_) => AddPatient(
              signedInUser: args,
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

      case '/patient-manager/patient/edit':
        if (args is Patient) {
          return MaterialPageRoute(
            builder: (_) => EditPatient(
              selectedPatient: args,
            ),
          );
        }
        return _errorRoute();

      case '/profile':
        if (args is AppUser) {
          return MaterialPageRoute(
            builder: (_) => ProfileUpdate(signedInUser: args),
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
