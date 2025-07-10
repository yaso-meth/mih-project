import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_print_prevew.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/Example/package_test.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_notification_message.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/about_mih.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/mih_policy_tos_ext/mih_privacy_polocy_external.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/mih_policy_tos_ext/mih_terms_of_service_external.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/mih_access.dart';
import 'package:mzansi_innovation_hub/mih_packages/authentication/auth_check.dart';
import 'package:mzansi_innovation_hub/mih_packages/authentication/forgot_password.dart';
import 'package:mzansi_innovation_hub/mih_packages/authentication/reset_password.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/mih_calculator.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/mzansi_calendar.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_authentication.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/mzansi_ai.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/mzansi_directory.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/profile_business_add.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_barcode_scanner.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/mih_wallet.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/pat_manager.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/add_or_view_patient.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/components/full_screen_file.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_add.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_edit.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_profile.dart';

// 1. Define Route Names as Constants
// This prevents typos and allows for easier refactoring.
// Consider moving this to a separate `lib/constants/app_routes.dart` file
// if your project grows larger.
class AppRoutes {
  // External
  static const String resetPasswordExternal = '/auth/reset-password';
  static const String privacyPolicyExternal = '/privacy-policy';
  static const String termsOfServiceExternal = '/terms-of-service';

  // Internal
  static const String authCheck = '/';
  static const String mihAuthentication = '/mih-authentication';
  static const String notifications = '/notifications';
  static const String forgotPassword = '/forgot-password';
  static const String aboutMih = '/about';
  static const String mzansiProfile = '/mzansi-profile';
  static const String mzansiProfileView = '/mzansi-profile/view';
  static const String businessProfileSetup = '/business-profile/set-up';
  static const String businessProfileManage = '/business-profile/manage';
  static const String patientProfile = '/patient-profile';
  static const String patientProfileSetup = '/patient-profile/set-up';
  static const String patientProfileEdit = '/patient-profile/edit';
  static const String mzansiWallet = '/mzansi-wallet';
  static const String mzansiDirectory = '/mzansi-directory';
  static const String mihAccess = '/mih-access';
  static const String calendar = '/calendar';
  static const String appointments = '/appointments';
  static const String patientManager = '/patient-manager';
  static const String patientManagerPatient = '/patient-manager/patient';
  static const String fileViewer = '/file-veiwer';
  static const String printPreview = '/file-veiwer/print-preview';
  static const String barcodeScanner = '/scanner';
  static const String calculator = '/calculator';
  static const String mzansiAi = '/mzansi-ai';
  static const String packageDevTest = '/package-dev';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final extPath =
        Uri.base.path; // Moved outside the internal switch for clarity

    // 2. Prioritize External Links
    // Using an if-else if chain for external routes might be slightly
    // more performant than a switch if there are many external routes,
    // as it avoids string hashing for each case. For a small number,
    // a switch is also fine.
    if (extPath == AppRoutes.resetPasswordExternal) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ResetPassword(token: Uri.base.queryParameters['token']),
      );
    } else if (extPath == AppRoutes.privacyPolicyExternal) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MIHPrivacyPolocyExternal(),
      );
    } else if (extPath == AppRoutes.termsOfServiceExternal) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MIHTermsOfServiceExternal(),
      );
    }

    // 3. Handle Internal Navigation with a Switch Statement
    // This switch now only deals with internal app routes, making it cleaner.
    switch (settings.name) {
      case AppRoutes.authCheck:
        if (args is AuthArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AuthCheck(
              personalSelected: args.personalSelected,
              firstBoot: args.firstBoot,
            ),
          );
        }
        break; // Use break and fall through to _errorRoute if argument type is wrong

      case AppRoutes.mihAuthentication:
        // if (args is AuthArguments) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MihAuthentication(),
        );
      // }
      // break; // Use break and fall through to _errorRoute if argument type is wrong
      case AppRoutes.mzansiDirectory:
        // if (args is AuthArguments) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MzansiDirectory(),
        );
      // }
      // break;
      case AppRoutes.notifications:
        if (args is NotificationArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MIHNotificationMessage(arguments: args),
          );
        }
        break;

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ForgotPassword());

      case AppRoutes.aboutMih:
        if (args is int) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AboutMih(packageIndex: args),
          );
        }
        break;

      case AppRoutes.mzansiProfile:
        if (args is AppProfileUpdateArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MzansiProfile(arguments: args),
          );
        }
        break;

      case AppRoutes.mzansiProfileView:
        if (args is AppUser) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MzansiProfileView(user: args),
          );
        }
        break;

      case AppRoutes.businessProfileSetup:
        if (args is AppUser) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ProfileBusinessAdd(signedInUser: args),
          );
        }
        break;

      case AppRoutes.businessProfileManage:
        if (args is BusinessArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MzansiBusinessProfile(arguments: args),
          );
        }
        break;

      case AppRoutes.patientProfile:
        if (args is PatientViewArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AddOrViewPatient(arguments: args),
          );
        }
        break;

      case AppRoutes.patientProfileSetup:
        if (args is AppUser) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AddPatient(signedInUser: args),
          );
        }
        break;

      case AppRoutes.patientProfileEdit:
        if (args is PatientEditArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => EditPatient(
              signedInUser: args.signedInUser,
              selectedPatient: args.selectedPatient,
            ),
          );
        }
        break;

      case AppRoutes.mzansiWallet:
        if (args is WalletArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MihWallet(arguments: args),
          );
        }
        break;

      case AppRoutes.mihAccess:
        if (args is AppUser) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MihAccess(signedInUser: args),
          );
        }
        break;

      // 4. Handle Calendar/Appointments - Unified to one case or keep separate as needed
      case AppRoutes.calendar:
      case AppRoutes
            .appointments: // Fall-through if both lead to the same screen
        if (args is CalendarArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MzansiCalendar(arguments: args),
          );
        }
        break;

      case AppRoutes.patientManager:
        if (args is PatManagerArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => PatManager(arguments: args),
          );
        }
        break;

      case AppRoutes.patientManagerPatient:
        if (args is PatientViewArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => PatientProfile(arguments: args),
          );
        }
        break;

      case AppRoutes.fileViewer:
        if (args is FileViewArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => FullScreenFileViewer(arguments: args),
          );
        }
        break;

      case AppRoutes.printPreview:
        if (args is PrintPreviewArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MIHPrintPreview(arguments: args),
          );
        }
        break;

      case AppRoutes.barcodeScanner:
        if (args is TextEditingController) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MihBarcodeScanner(cardNumberController: args),
          );
        }
        break;

      case AppRoutes.calculator:
        if (args is bool) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MIHCalculator(personalSelected: args),
          );
        }
        break;

      case AppRoutes.mzansiAi:
        if (args is MzansiAiArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => MzansiAi(arguments: args),
          );
        }
        break;

      case AppRoutes.packageDevTest:
        if (args is TestArguments) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => PackageTest(arguments: args),
          );
        }
        break;

      default:
        // If no match is found, fall through to the error route
        break;
    }

    // 5. Consolidated Error Route Call
    // If any of the internal cases fail (e.g., wrong argument type or no matching route),
    // it will fall through here.
    return _errorRoute();
  }

  // 6. Refined Error Route
  // Providing a simple, clear error message or redirection.
  static Route<dynamic> _errorRoute() {
    debugPrint(
        "Invalid Route or Missing/Incorrect Arguments"); // Use debugPrint for development logs
    return MaterialPageRoute(
      settings: const RouteSettings(name: AppRoutes.authCheck),
      builder: (_) => const AuthCheck(
        personalSelected: true,
        firstBoot: true,
      ),
    );
  }
}
