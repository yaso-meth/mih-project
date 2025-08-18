import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/authentication/auth_check.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/mzansi_business_profile_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/profile_business_add.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/mzansi_profile_view.dart';
import 'package:ken_logger/ken_logger.dart';

class MihGoRouterPaths {
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
    initialLocation: MihGoRouterPaths.authCheck,
    routes: [
      // External Routes - use `GoRoute` with `path` and `builder`
      // GoRoute(
      //   name: "resetPasswordExternal",
      //   path: MihGoRouterPaths.resetPasswordExternal,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final token = state.queryParameters['token'];
      //     return ResetPassword(token: token);
      //   },
      // ),
      // GoRoute(
      //   name: "privacyPolicyExternal",
      //   path: MihGoRouterPaths.privacyPolicyExternal,
      //   builder: (BuildContext context, GoRouterState state) =>
      //       const MIHPrivacyPolocyExternal(),
      // ),
      // GoRoute(
      //   name: "termsOfServiceExternal",
      //   path: MihGoRouterPaths.termsOfServiceExternal,
      //   builder: (BuildContext context, GoRouterState state) =>
      //       const MIHTermsOfServiceExternal(),
      // ),

      // Internal Routes - handle arguments via `extra` or path parameters
      GoRoute(
        name: "home",
        path: MihGoRouterPaths.authCheck,
        builder: (BuildContext context, GoRouterState state) {
          final AuthArguments? args = state.extra as AuthArguments?;
          KenLogger.success("Inside MihGoRouter: home");
          return AuthCheck(
            personalSelected: args?.personalSelected ?? true,
            firstBoot: args?.firstBoot ?? true,
          );
        },
      ),
      GoRoute(
        name: "mzansiProfileManage",
        path: MihGoRouterPaths.mzansiProfileManage,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("Inside MihGoRouter: mzansiProfileManage");
          final AppProfileUpdateArguments? args =
              state.extra as AppProfileUpdateArguments?;
          return MzansiProfile(arguments: args!);
        },
      ),
      GoRoute(
        name: "mzansiProfileView",
        path: MihGoRouterPaths.mzansiProfileView,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("Inside MihGoRouter: mzansiProfileView");
          final AppUser? user = state.extra as AppUser?;
          return MzansiProfileView(user: user!);
        },
      ),
      GoRoute(
        name: "businessProfileSetup",
        path: MihGoRouterPaths.businessProfileSetup,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("Inside MihGoRouter: businessProfileSetup");
          final AppUser? signedInUser = state.extra as AppUser?;
          return ProfileBusinessAdd(signedInUser: signedInUser!);
        },
      ),
      GoRoute(
        name: "businessProfileManage",
        path: MihGoRouterPaths.businessProfileManage,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("Inside MihGoRouter: businessProfileManage");
          final BusinessArguments? args = state.extra as BusinessArguments?;
          return MzansiBusinessProfile(arguments: args!);
        },
      ),
      GoRoute(
        name: "businessProfileView",
        path: MihGoRouterPaths.businessProfileView,
        builder: (BuildContext context, GoRouterState state) {
          KenLogger.success("Inside MihGoRouter: businessProfileView");
          final BusinessViewArguments? args =
              state.extra as BusinessViewArguments?;
          return MzansiBusinessProfileView(arguments: args!);
        },
      ),
//     GoRoute(
//       name: "mihAuthentication",
//       path: MihGoRouterPaths.mihAuthentication,
//       builder: (BuildContext context, GoRouterState state) =>
//           MihAuthentication(),
//     ),
//     GoRoute(
//       name: "mzansiDirectory",
//       path: MihGoRouterPaths.mzansiDirectory,
//       builder: (BuildContext context, GoRouterState state) {
//         final MzansiDirectoryArguments? args = state.extra as MzansiDirectoryArguments?;
//         return MzansiDirectory(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "notifications",
//       path: MihGoRouterPaths.notifications,
//       builder: (BuildContext context, GoRouterState state) {
//         final NotificationArguments? args = state.extra as NotificationArguments?;
//         return MIHNotificationMessage(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "forgotPassword",
//       path: MihGoRouterPaths.forgotPassword,
//       builder: (BuildContext context, GoRouterState state) =>
//           const ForgotPassword(),
//     ),
//     GoRoute(
//       name: "aboutMih",
//       path: MihGoRouterPaths.aboutMih,
//       builder: (BuildContext context, GoRouterState state) {
//         final int? packageIndex = state.extra as int?;
//         return AboutMih(packageIndex: packageIndex);
//       },
//     ),
//     GoRoute(
//       name: "patientProfile",
//       path: MihGoRouterPaths.patientProfile,
//       builder: (BuildContext context, GoRouterState state) {
//         final PatientViewArguments? args = state.extra as PatientViewArguments?;
//         return AddOrViewPatient(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "patientProfileSetup",
//       path: MihGoRouterPaths.patientProfileSetup,
//       builder: (BuildContext context, GoRouterState state) {
//         final AppUser? signedInUser = state.extra as AppUser?;
//         return AddPatient(signedInUser: signedInUser!);
//       },
//     ),
//     GoRoute(
//       name: "patientProfileEdit",
//       path: MihGoRouterPaths.patientProfileEdit,
//       builder: (BuildContext context, GoRouterState state) {
//         final PatientEditArguments? args = state.extra as PatientEditArguments?;
//         return EditPatient(
//           signedInUser: args!.signedInUser,
//           selectedPatient: args.selectedPatient,
//         );
//       },
//     ),
//     GoRoute(
//       name: "mzansiWallet",
//       path: MihGoRouterPaths.mzansiWallet,
//       builder: (BuildContext context, GoRouterState state) {
//         final WalletArguments? args = state.extra as WalletArguments?;
//         return MihWallet(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "mihAccess",
//       path: MihGoRouterPaths.mihAccess,
//       builder: (BuildContext context, GoRouterState state) {
//         final AppUser? signedInUser = state.extra as AppUser?;
//         return MihAccess(signedInUser: signedInUser!);
//       },
//     ),
//     GoRoute(
//       name: "mihCalendar",
//       path: MihGoRouterPaths.calendar,
//       builder: (BuildContext context, GoRouterState state) {
//         final CalendarArguments? args = state.extra as CalendarArguments?;
//         return MzansiCalendar(arguments: args!);
//       },
//     ),
//     // Note: You can't have two separate GoRoutes with the same path.
//     // 'appointments' and 'calendar' now need a distinct path, or be sub-routes.
//     // Here, we'll assume they should be separate.
//     GoRoute(
//       name: "mihAppointments",
//       path: MihGoRouterPaths.appointments,
//       builder: (BuildContext context, GoRouterState state) {
//         final CalendarArguments? args = state.extra as CalendarArguments?;
//         return MzansiCalendar(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "patientManager",
//       path: MihGoRouterPaths.patientManager,
//       builder: (BuildContext context, GoRouterState state) {
//         final PatManagerArguments? args = state.extra as PatManagerArguments?;
//         return PatManager(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "patientManagerPatient",
//       path: MihGoRouterPaths.patientManagerPatient,
//       builder: (BuildContext context, GoRouterState state) {
//         final PatientViewArguments? args = state.extra as PatientViewArguments?;
//         return PatientProfile(arguments: args!);
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
//     GoRoute(
//       name: "barcodeScanner",
//       path: MihGoRouterPaths.barcodeScanner,
//       builder: (BuildContext context, GoRouterState state) {
//         final TextEditingController? args = state.extra as TextEditingController?;
//         return MihBarcodeScanner(cardNumberController: args!);
//       },
//     ),
//     GoRoute(
//       name: "mihCalculator",
//       path: MihGoRouterPaths.calculator,
//       builder: (BuildContext context, GoRouterState state) {
//         final bool? personalSelected = state.extra as bool?;
//         return MIHCalculator(personalSelected: personalSelected!);
//       },
//     ),
//     GoRoute(
//       name: "mzansiAi",
//       path: MihGoRouterPaths.mzansiAi,
//       builder: (BuildContext context, GoRouterState state) {
//         final MzansiAiArguments? args = state.extra as MzansiAiArguments?;
//         return MzansiAi(arguments: args!);
//       },
//     ),
//     GoRoute(
//       name: "testPackage",
//       path: MihGoRouterPaths.packageDevTest,
//       builder: (BuildContext context, GoRouterState state) {
//         final TestArguments? args = state.extra as TestArguments?;
//         return PackageTest(arguments: args!);
//       },
//     ),
    ],
    // 3. Error handling with `errorBuilder` and `redirect`
    errorBuilder: (BuildContext context, GoRouterState state) {
      KenLogger.error('Invalid Route');
      return const AuthCheck(personalSelected: true, firstBoot: true);
    },
  );
}
