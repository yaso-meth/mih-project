import 'package:flutter/material.dart';
import 'package:patient_manager/Authentication/authCheck.dart';
import 'package:patient_manager/components/addOrViewPatient.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/signInOrRegister.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:patient_manager/pages/patientAdd.dart';
import 'package:patient_manager/pages/patientEdit.dart';
import 'package:patient_manager/pages/patientManager.dart';
import 'package:patient_manager/pages/patientView.dart';
import 'package:patient_manager/pages/profileBusinessAdd.dart';
import 'package:patient_manager/pages/profileBusinessUpdate.dart';
import 'package:patient_manager/pages/profileUserUpdate.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const AuthCheck());

      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());

      case '/patient-profile':
        if (args is PatientViewArguments) {
          //print("route generator: $args");
          return MaterialPageRoute(
            builder: (_) => AddOrViewPatient(
              arguments: args,
            ),
          );
        }
        return _errorRoute();

      case '/patient-manager':
        if (args is AppUser) {
          //print("route generator: $args");
          return MaterialPageRoute(
            builder: (_) => PatientManager(
              signedInUser: args,
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
        if (args is PatientViewArguments) {
          return MaterialPageRoute(
            builder: (_) => PatientView(
              arguments: args,
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
            builder: (_) => ProfileUserUpdate(
              signedInUser: args,
            ),
          );
        }
        return _errorRoute();

      case '/business-profile':
        if (args is BusinessUpdateArguments) {
          return MaterialPageRoute(
            builder: (_) => ProfileBusinessUpdate(
              arguments: args,
            ),
          );
        }
        return _errorRoute();

      case '/business/add':
        if (args is AppUser) {
          return MaterialPageRoute(
            builder: (_) => ProfileBusinessAdd(
              signedInUser: args,
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
      appBar: MIHAppBar(barTitle: "Error"),
      body: Center(
        child: Text("Error"),
      ),
    );
  });
}
