import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/Example/package_test.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/about_mih.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/mih_access.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/mih_calculator.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/mzansi_calendar.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_auth_forgot_password.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_auth_password_reset.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_authentication.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_home.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/mzansi_ai.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/mzansi_directory.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/profile_business_add.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile_view.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_barcode_scanner.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/mih_wallet.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/pat_manager.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/add_or_view_patient.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_edit.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_profile.dart';
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
          if (state.extra != null) {
            final bool personalSelected = state.extra as bool;
            return MihHome(
              key: UniqueKey(),
              personalSelected: personalSelected,
            );
          }
          return MihHome(
            key: UniqueKey(),
            personalSelected: true,
          );
        },
      ),
      // ========================== About MIH ==================================
      GoRoute(
        name: "aboutMih",
        path: MihGoRouterPaths.aboutMih,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: aboutMih");
          final int? packageIndex = state.extra as int?;
          int index = 0;
          if (packageIndex != null) {
            index = packageIndex;
          }
          return AboutMih(packageIndex: index);
        },
      ),
      // ========================== Mzansi Profile Personal ==================================
      GoRoute(
        name: "mzansiProfileManage",
        path: MihGoRouterPaths.mzansiProfileManage,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiProfileManage");
          final AppProfileUpdateArguments? args =
              state.extra as AppProfileUpdateArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiProfile(arguments: args);
        },
      ),
      GoRoute(
        name: "mzansiProfileView",
        path: MihGoRouterPaths.mzansiProfileView,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiProfileView");
          final AppUser? user = state.extra as AppUser?;
          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiProfileView(user: user);
        },
      ),
      // ========================== Mzansi Profile Business ==================================
      GoRoute(
        name: "businessProfileManage",
        path: MihGoRouterPaths.businessProfileManage,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: businessProfileManage");
          final BusinessArguments? args = state.extra as BusinessArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiBusinessProfile(
            key: UniqueKey(),
            arguments: args,
          );
        },
      ),
      GoRoute(
        name: "businessProfileView",
        path: MihGoRouterPaths.businessProfileView,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: businessProfileView");
          String? businessId = state.uri.queryParameters['business_id'];
          KenLogger.success("businessId: $businessId");
          final BusinessViewArguments? args =
              state.extra as BusinessViewArguments?;
          if (args == null && businessId == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiBusinessProfileView(
            key: UniqueKey(),
            arguments: args,
            businessId: businessId,
          );
        },
      ),
      GoRoute(
        name: "businessProfileSetup",
        path: MihGoRouterPaths.businessProfileSetup,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: businessProfileSetup");
          final AppUser? signedInUser = state.extra as AppUser?;
          return ProfileBusinessAdd(signedInUser: signedInUser!);
        },
      ),
      // ========================== MIH Calculator ==================================
      GoRoute(
        name: "mihCalculator",
        path: MihGoRouterPaths.calculator,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihCalculator");
          final bool? personalSelected = state.extra as bool?;
          bool personal = true;
          if (personalSelected != null) {
            personal = personalSelected;
          }
          return MIHCalculator(personalSelected: personal);
        },
      ),
      // ========================== MIH Calculator ==================================
      GoRoute(
        name: "mihCalendar",
        path: MihGoRouterPaths.calendar,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mihCalendar");
          final CalendarArguments? args = state.extra as CalendarArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiCalendar(
            key: UniqueKey(),
            arguments: args,
          );
        },
      ),
      // ========================== Mzansi AI ==================================
      GoRoute(
        name: "mzansiAi",
        path: MihGoRouterPaths.mzansiAi,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiAi");
          final MzansiAiArguments? args = state.extra as MzansiAiArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiAi(arguments: args);
        },
      ),
      // ========================== Mzansi Wallet ==================================
      GoRoute(
        name: "mzansiWallet",
        path: MihGoRouterPaths.mzansiWallet,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("MihGoRouter: mzansiWallet");
          final WalletArguments? args = state.extra as WalletArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MihWallet(
            key: UniqueKey(),
            arguments: args,
          );
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
          final TestArguments? args = state.extra as TestArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return PackageTest(arguments: args);
        },
      ),
      // ========================== MIH Access Controls ==================================
      GoRoute(
        name: "mihAccess",
        path: MihGoRouterPaths.mihAccess,
        builder: (BuildContext context, GoRouterState state) {
          final AppUser? signedInUser = state.extra as AppUser?;
          if (signedInUser == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MihAccess(
            key: UniqueKey(),
            signedInUser: signedInUser,
          );
        },
      ),
      // ========================== Patient Profile ==================================
      GoRoute(
        name: "patientProfile",
        path: MihGoRouterPaths.patientProfile,
        builder: (BuildContext context, GoRouterState state) {
          final PatientViewArguments? args =
              state.extra as PatientViewArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return AddOrViewPatient(
            key: UniqueKey(),
            arguments: args,
          );
        },
      ),
      GoRoute(
        name: "patientProfileEdit",
        path: MihGoRouterPaths.patientProfileEdit,
        builder: (BuildContext context, GoRouterState state) {
          final PatientEditArguments? args =
              state.extra as PatientEditArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return EditPatient(
            signedInUser: args.signedInUser,
            selectedPatient: args.selectedPatient,
          );
        },
      ),
      GoRoute(
        name: "patientManager",
        path: MihGoRouterPaths.patientManager,
        builder: (BuildContext context, GoRouterState state) {
          final PatManagerArguments? args = state.extra as PatManagerArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return PatManager(
            key: UniqueKey(),
            arguments: args,
          );
        },
      ),
      GoRoute(
        name: "patientManagerPatient",
        path: MihGoRouterPaths.patientManagerPatient,
        builder: (BuildContext context, GoRouterState state) {
          final PatientViewArguments? args =
              state.extra as PatientViewArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return PatientProfile(arguments: args);
        },
      ),
      // ========================== Mzansi Directory ==================================
      GoRoute(
        name: "mzansiDirectory",
        path: MihGoRouterPaths.mzansiDirectory,
        builder: (BuildContext context, GoRouterState state) {
          final MzansiDirectoryArguments? args =
              state.extra as MzansiDirectoryArguments?;
          if (args == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(MihGoRouterPaths.mihHome);
            });
            return const SizedBox.shrink();
          }
          return MzansiDirectory(arguments: args);
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
//     GoRoute(
//       name: "fileViewer",
//       path: MihGoRouterPaths.fileViewer,
//       builder: (BuildContext context, GoRouterState state) {
//         final FileViewArguments? args = state.extra as FileViewArguments?;
//         return FullScreenFileViewer(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "printPreview",
//       path: MihGoRouterPaths.printPreview,
//       builder: (BuildContext context, GoRouterState state) {
//         final PrintPreviewArguments? args = state.extra as PrintPreviewArguments?;
//         return MIHPrintPreview(arguments: args!);
//       },
//     ),
    ],
    // 3. Error handling with `errorBuilder` and `redirect`
    errorBuilder: (BuildContext context, GoRouterState state) {
      KenLogger.error('Invalid Route');
      return const Placeholder();
    },
  );
}
