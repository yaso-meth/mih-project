import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_file_viewer/components/mih_print_prevew.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/Example/package_test.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/about_mih.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/mih_access.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/mih_calculator.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/mzansi_calendar.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_auth_forgot_password.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_auth_password_reset.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_authentication.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_file_viewer/mih_fle_viewer.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_home.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_route_error.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/mih_mine_sweeper.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/mzansi_ai.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/mzansi_directory.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/busines_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_set_up_business_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile_view.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_barcode_scanner.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/mih_wallet.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/pat_manager.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/patient_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/patient_set_up.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MihGoRouterPaths {
  // External
  static const String resetPassword = '/auth/reset-password';
  static const String privacyPolicyExternal = '/privacy-policy';
  static const String termsOfServiceExternal = '/terms-of-service';

  // Internal
  // static const String authCheck = '/';
  static const String mihAuthentication = '/mih-authentication';
  static const String mihHome = '/';
  static const String notifications = '/notifications';
  static const String forgotPassword = '/mih-authentication/forgot-password';
  static const String aboutMih = '/about';
  static const String mzansiProfileManage = '/mzansi-profile';
  static const String mzansiProfileView = '/mzansi-profile/view';
  static const String businessProfileSetup = '/business-profile/set-up';
  static const String businessProfileManage = '/business-profile/manage';
  static const String businessProfileView = '/business-profile/view';
  static const String patientProfile = '/patient-profile';
  static const String patientProfileSetup = '/patient-profile/set-up';
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
  static const String mihMineSweeper = '/mih-minesweeper';
  static const String packageDevTest = '/package-dev';
}

class MihGoRouter {
  final GoRouter mihRouter = GoRouter(
    initialLocation: MihGoRouterPaths.mihHome,
    redirect: (BuildContext context, GoRouterState state) async {
      final bool isUserSignedIn = await SuperTokens.doesSessionExist();
      final unauthenticatedPaths = [
        MihGoRouterPaths.mihAuthentication,
        MihGoRouterPaths.forgotPassword,
        MihGoRouterPaths.resetPassword,
        MihGoRouterPaths.aboutMih,
        MihGoRouterPaths.businessProfileView,
      ];
      KenLogger.success(
          "Redirect Check: ${state.fullPath}, isUserSignedIn: $isUserSignedIn");
      if (!isUserSignedIn && !unauthenticatedPaths.contains(state.fullPath)) {
        return MihGoRouterPaths.mihAuthentication;
      }
      if (isUserSignedIn &&
          unauthenticatedPaths.contains(state.fullPath) &&
          state.fullPath != MihGoRouterPaths.aboutMih &&
          state.fullPath != MihGoRouterPaths.businessProfileView) {
        return MihGoRouterPaths.mihHome;
      }
      return null; // Stay on current route
    },
    routes: [
      // ========================== MIH Auth ==================================
      GoRoute(
        name: "mihAuthentication",
        path: MihGoRouterPaths.mihAuthentication,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihAuthentication");
          return MihAuthentication();
        },
      ),
      GoRoute(
        name: "forgotPassword",
        path: MihGoRouterPaths.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: forgotPassword");
          return const MihAuthForgotPassword();
        },
      ),
      GoRoute(
        name: "resetPassword",
        path: MihGoRouterPaths.resetPassword,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: resetPassword");
          String? token = state.uri.queryParameters['token'];
          KenLogger.success("token: $token");
          if (token == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MihAuthPasswordReset(token: token);
        },
      ),
      // ========================== MIH Home ==================================
      GoRoute(
        name: "mihHome",
        path: MihGoRouterPaths.mihHome,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihHome");
          return MihHome(
            key: UniqueKey(),
          );
        },
      ),
      // ========================== About MIH ==================================
      GoRoute(
        name: "aboutMih",
        path: MihGoRouterPaths.aboutMih,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: aboutMih");
          return AboutMih();
        },
      ),
      // ========================== Mzansi Profile Personal ==================================
      GoRoute(
        name: "mzansiProfileManage",
        path: MihGoRouterPaths.mzansiProfileManage,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiProfileManage");
          return MzansiProfile();
        },
      ),
      GoRoute(
        name: "mzansiProfileView",
        path: MihGoRouterPaths.mzansiProfileView,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiProfileView");
          MzansiDirectoryProvider directoryProvider =
              context.read<MzansiDirectoryProvider>();
          if (directoryProvider.selectedUser == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiProfileView();
        },
      ),
      // ========================== Mzansi Profile Business ==================================
      GoRoute(
        name: "businessProfileManage",
        path: MihGoRouterPaths.businessProfileManage,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: businessProfileManage");
          return BusinesProfile();
        },
      ),
      GoRoute(
        name: "businessProfileView",
        path: MihGoRouterPaths.businessProfileView,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: businessProfileView");
          String? businessId = state.uri.queryParameters['business_id'];
          KenLogger.success("businessId: $businessId");
          MzansiDirectoryProvider directoryProvider =
              context.read<MzansiDirectoryProvider>();
          if (directoryProvider.selectedBusiness == null &&
              businessId == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiBusinessProfileView(
            businessId: businessId,
          );
        },
      ),
      GoRoute(
        name: "businessProfileSetup",
        path: MihGoRouterPaths.businessProfileSetup,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: businessProfileSetup");
          return MzansiSetUpBusinessProfile();
        },
      ),
      // ========================== MIH Calculator ==================================
      GoRoute(
        name: "mihCalculator",
        path: MihGoRouterPaths.calculator,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihCalculator");
          return MIHCalculator();
        },
      ),
      // ========================== MIH Calculator ==================================
      GoRoute(
        name: "mihCalendar",
        path: MihGoRouterPaths.calendar,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihCalendar");
          return MzansiCalendar();
        },
      ),
      // ========================== Mzansi AI ==================================
      GoRoute(
        name: "mzansiAi",
        path: MihGoRouterPaths.mzansiAi,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiAi");
          return MzansiAi();
        },
      ),
      // ========================== Mzansi Wallet ==================================
      GoRoute(
        name: "mzansiWallet",
        path: MihGoRouterPaths.mzansiWallet,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiWallet");
          return MihWallet();
        },
      ),
      GoRoute(
        name: "barcodeScanner",
        path: MihGoRouterPaths.barcodeScanner,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: barcodeScanner");
          final TextEditingController? args =
              state.extra as TextEditingController?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MihBarcodeScanner(cardNumberController: args);
        },
      ),
      // ========================== Test Package ==================================
      GoRoute(
        name: "testPackage",
        path: MihGoRouterPaths.packageDevTest,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: testPackage");
          return PackageTest();
        },
      ),
      // ========================== MIH Access Controls ==================================
      GoRoute(
        name: "mihAccess",
        path: MihGoRouterPaths.mihAccess,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihAccess");
          return MihAccess();
        },
      ),
      // ========================== Patient Profile ==================================
      GoRoute(
        name: "patientProfile",
        path: MihGoRouterPaths.patientProfile,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: patientProfile");
          return PatientProfile();
        },
      ),
      GoRoute(
        name: "patientProfileSetup",
        path: MihGoRouterPaths.patientProfileSetup,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: patientProfileSetup");
          return PatientSetUp();
        },
      ),
      GoRoute(
        name: "patientManager",
        path: MihGoRouterPaths.patientManager,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: patientManager");
          return PatManager();
        },
      ),
      GoRoute(
        name: "patientManagerPatient",
        path: MihGoRouterPaths.patientManagerPatient,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: patientManagerPatient");
          return PatientProfile();
        },
      ),
      // ========================== Mzansi Directory ==================================
      GoRoute(
        name: "mzansiDirectory",
        path: MihGoRouterPaths.mzansiDirectory,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiDirectory");
          return MzansiDirectory();
        },
      ),
      // ========================== End ==================================
      GoRoute(
        name: "fileViewer",
        path: MihGoRouterPaths.fileViewer,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: fileViewer");
          return MihFleViewer();
        },
      ),
      GoRoute(
        name: "printPreview",
        path: MihGoRouterPaths.printPreview,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: printPreview");
          final PrintPreviewArguments? args =
              state.extra as PrintPreviewArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MIHPrintPreview(arguments: args);
        },
      ),
      // ========================== MIH Minesweeper ==================================
      GoRoute(
        name: "mihMinesweeper",
        path: MihGoRouterPaths.mihMineSweeper,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihMineSweeper");
          return MihMineSweeper();
        },
      ),
      // ========================== End ==================================
//     GoRoute(
//       name: "notifications",
//       path: MihGoRouterPaths.notifications,
//       builder: (BuildContext context, GoRouterState state) {
//         final NotificationArguments? args = state.extra as NotificationArguments?;
//         return MIHNotificationMessage(arguments: args!);
//       },
//     ),
    ],
    // 3. Error handling with `errorBuilder` and `redirect`
    errorBuilder: (BuildContext context, GoRouterState state) {
      KenLogger.error('Invalid Route');
      return const MihRouteError();
    },
  );
}
