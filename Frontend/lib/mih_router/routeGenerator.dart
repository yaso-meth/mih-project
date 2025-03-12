import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/test/package_test.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/about_mih.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/mih_policy_tos_ext/mih_privacy_polocy_external.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/mih_policy_tos_ext/mih_terms_of_service_external.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/access_review/mih_access.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/mih_calculator.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calendar/mzansi_calendar.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_ai/mzansi_ai.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/components/mih_barcode_scanner.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/mih_wallet.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_manager/pat_manager.dart';
import 'package:flutter/material.dart';
import '../mih_components/mih_layout/mih_print_prevew.dart';
import '../mih_components/mih_pop_up_messages/mih_notification_message.dart';
import '../mih_packages/authentication/auth_check.dart';
import '../mih_packages/patient_profile/add_or_view_patient.dart';
import '../mih_packages/patient_profile/patient_add.dart';
import '../mih_packages/patient_profile/patient_edit.dart';
import '../mih_objects/app_user.dart';
import '../mih_objects/arguments.dart';
import '../mih_packages/authentication/forgot_password.dart';
import '../mih_packages/authentication/reset_password.dart';
import '../mih_packages/patient_profile/full_screen_file.dart';
import '../mih_packages/patient_profile/patient_view.dart';
import '../mih_packages/manage_business/profile_business_add.dart';

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
      //Privacy Policy
      case '/privacy-policy':
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MIHPrivacyPolocyExternal());
      //===============================================================

      //Terms Of Service
      case '/terms-of-service':
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MIHTermsOfServiceExternal());
      //===============================================================
      default:
        // Internal Navigation
        switch (settings.name) {
          // Authgentication
          case '/':
            if (args is AuthArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => AuthCheck(
                  personalSelected: args.personalSelected,
                  firstBoot: args.firstBoot,
                ),
              );
            }
            return _errorRoute();
          case '/notifications':
            if (args is NotificationArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MIHNotificationMessage(
                  arguments: args,
                ),
              );
            }
            return _errorRoute();
          case '/forgot-password':
            return MaterialPageRoute(
                settings: settings, builder: (_) => const ForgotPassword());
          //http://mzansi-innovation-hub.co.za/auth/reset-password
          //===============================================================

          //About MIH
          case '/about':
            if (args is int) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => AboutMih(
                  packageIndex: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Privacy Policy
          case '/privacy-policy':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const MIHPrivacyPolocyExternal());
          //===============================================================

          //Terms Of Service
          case '/terms-of-service':
            return MaterialPageRoute(
                settings: settings,
                builder: (_) => const MIHTermsOfServiceExternal());
          //===============================================================

          //User Profile
          case '/user-profile':
            if (args is AppProfileUpdateArguments) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MzansiProfile(arguments: args),
                // ProfileUserUpdate(
                //   arguments: args,
                // ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Business Profile Pages
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
                builder: (_) => MzansiBusinessProfile(
                  arguments: args,
                ),
                // ManageBusinessProfile(
                //   arguments: args,
                // ),
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

          // /mzansi wallet
          case '/mzansi-wallet':
            if (args is AppUser) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MihWallet(
                  signedInUser: args,
                ),
                // MzansiWallet(
                //   signedInUser: args,
                // ),
              );
            }
            return _errorRoute();
          //===============================================================

          // Access Review Page
          case '/mih-access':
            if (args is AppUser) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MihAccess(
                  signedInUser: args,
                ),
                // PatientAccessRequest(
                //   signedInUser: args,
                // ),
              );
            }
            return _errorRoute();
          //===============================================================

          // Appointment Page
          case '/calendar':
            if (args is CalendarArguments) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MzansiCalendar(
                  arguments: args,
                ),
                //     Appointments(
                //   signedInUser: args,
                // ),
              );
            }
            return _errorRoute();
          case '/appointments':
            if (args is CalendarArguments) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MzansiCalendar(
                  arguments: args,
                ),
                //     Appointments(
                //   signedInUser: args,
                // ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Patient Manager Pages
          case '/patient-manager':
            if (args is PatManagerArguments) {
              //print("route generator: $args");
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => PatManager(
                  arguments: args,
                ),
                // PatientManager(
                //   arguments: args,
                // ),
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
          //===============================================================

          //Full Screen File Viewer
          case '/scanner':
            if (args is TextEditingController) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MihBarcodeScanner(
                  cardNumberController: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Calculator
          case '/calculator':
            if (args is bool) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MIHCalculator(
                  personalSelected: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //===============================================================

          //Mzansi AI
          case '/mzansi-ai':
            if (args is AppUser) {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => MzansiAi(
                  signedInUser: args,
                ),
              );
            }
            return _errorRoute();
          //===============================================================

          //Package Ttemplate Test
          case '/package-dev':
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const PackageTest(),
            );

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
      builder: (_) => const AuthCheck(
            personalSelected: true,
            firstBoot: true,
          ));
  // return MaterialPageRoute(builder: (_) {
  //   return const Scaffold(
  //     appBar: MIHAppBar(barTitle: "Error"),
  //     body: Center(
  //       child: Text("Error"),
  //     ),
  //   );
  // });
}
