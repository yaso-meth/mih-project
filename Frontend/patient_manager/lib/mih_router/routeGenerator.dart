import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_print_prevew.dart';
import 'package:patient_manager/mih_packages/authentication/auth_check.dart';
import 'package:patient_manager/mih_packages/patient_profile/add_or_view_patient.dart';
import 'package:patient_manager/mih_packages/patient_profile/patient_add.dart';
import 'package:patient_manager/mih_packages/patient_profile/patient_edit.dart';
import 'package:patient_manager/mih_packages/patient_profile/patient_manager.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_packages/about_mih/mih_about.dart';
import 'package:patient_manager/mih_packages/authentication/forgot_password.dart';
import 'package:patient_manager/mih_packages/authentication/reset_password.dart';
import 'package:patient_manager/mih_packages/patient_profile/full_screen_file.dart';
import 'package:patient_manager/mih_packages/manage_business/manage_business_profile.dart';
import 'package:patient_manager/mih_packages/access_review/patient_access_review.dart';

import 'package:patient_manager/mih_packages/patient_profile/patient_view.dart';
import 'package:patient_manager/mih_packages/manage_business/profile_business_add.dart';
import 'package:patient_manager/mih_packages/manage_business/business_details.dart';
import 'package:patient_manager/mih_packages/mzansi_profile/profile_user_update.dart';

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
                settings: settings, builder: (_) => const MIHAbout());
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
                builder: (_) => BusinessDetails(
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
          case '/file-veiwer/print-preview':
            if (args is PrintPreviewArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MIHPrintPreview(
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
  print("Invalid Route");
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
