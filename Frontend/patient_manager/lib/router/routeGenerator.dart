import 'package:flutter/material.dart';
import 'package:patient_manager/Authentication/authCheck.dart';
import 'package:patient_manager/components/addOrViewPatient.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/pages/about/MIH_About.dart';
import 'package:patient_manager/pages/authentication/forgotPassword.dart';
import 'package:patient_manager/pages/authentication/resetPassword.dart';
import 'package:patient_manager/pages/fullScreenFile.dart';
import 'package:patient_manager/pages/manageBusinessProfile.dart';
import 'package:patient_manager/pages/patientAccessReview.dart';
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
    var extPath = Uri.base.path;
    // print(extPath);
    // print(settings.name);
    // External Links Navigation
    switch (extPath) {
      case '/auth/reset-password':
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ResetPassword(
                  token: Uri.base.queryParameters['token'],
                ));
      case '/about':
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MIHAbout());
      default:
        // Internal Navigation
        switch (settings.name) {
          // Authgentication
          case '/':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const AuthCheck());
          case '/forgot-password':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const ForgotPassword());
          //http://mzansi-innovation-hub.co.za/auth/reset-password
          //===============================================================
          
          //About MIH
          case '/about':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const MIHAbout());
          //===============================================================

          //User Profile
          case '/user-profile':
            if (args is AppProfileUpdateArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ProfileUserUpdate(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Business Profile Pages
          case '/business-profile':
            if (args is BusinessArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ProfileBusinessUpdate(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          case '/business-profile/set-up':
            if (args is AppUser) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ProfileBusinessAdd(
                  signedInUser: args,
                ),
              );
            }
            return _errorRoute();
          case '/business-profile/manage':
            if (args is BusinessArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => ManageBusinessProfile(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          // Patient Profile Pages
          case '/patient-profile':
            if (args is PatientViewArguments) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => AddOrViewPatient(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          case '/patient-profile/set-up':
            if (args is AppUser) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => AddPatient(
                  signedInUser: args,
                ),
              );
            }
            return _errorRoute();
          case '/patient-profile/edit':
            if (args is PatientEditArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => EditPatient(
                  signedInUser: args.signedInUser,
                  selectedPatient: args.selectedPatient,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          // Access Review Page
          case '/access-review':
            if (args is AppUser) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => PatientAccessRequest(
                  signedInUser: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Patient Manager Pages
          case '/patient-manager':
            if (args is BusinessArguments) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => PatientManager(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          case '/patient-manager/patient':
            if (args is PatientViewArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => PatientView(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Full Screen File Viewer
          case '/file-veiwer':
            if (args is FileViewArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => FullScreenFileViewer(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          default:
            return _errorRoute();
        }
    }
  }
}

Route<dynamic> _errorRoute() {
  print("error");
  return MaterialPageRoute(
      settings: const RouteSettings(name: '/'),
      builder: (_) => const AuthCheck());
  // return MaterialPageRoute(builder: (_) {
  //   return const Scaffold(
  //     appBar: MIHAppBar(barTitle: "Error"),
  //     body: Center(
  //       child: Text("Error"),
  //     ),
  //   );
  // });
}
