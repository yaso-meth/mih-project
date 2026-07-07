import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_consent_services.dart';
import 'package:provider/provider.dart';

class MihUserConsentWindow extends StatefulWidget {
  const MihUserConsentWindow({super.key});

  @override
  State<MihUserConsentWindow> createState() => _MihUserConsentWindowState();
}

class _MihUserConsentWindowState extends State<MihUserConsentWindow> {
  void createOrUpdateAccpetance(
      MzansiProfileProvider mzansiProfileProvider) async {
    UserConsent? userConsent = mzansiProfileProvider.userConsent;
    if (userConsent != null) {
      MihUserConsentServices()
          .updateUserConsentStatus(
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
        mzansiProfileProvider,
        context,
      )
          .then((value) {
        if (!mounted) return;
        if (value == 200) {
          context.goNamed("mihHome");
          ScaffoldMessenger.of(context).showSnackBar(
            MihSnackBar(
              child: Text("Thank you for accepting our Policies"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            MihSnackBar(
              child: Text("There was an error, please try again later"),
            ),
          );
        }
      });
    } else {
      bool success = await mzansiProfileProvider.addUserConsent(UserConsent(
        app_id: mzansiProfileProvider.user!.app_id,
        privacy_policy_accepted: DateTime.now(),
        terms_of_services_accepted: DateTime.now(),
      ));
      if (success) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          MihSnackBar(
            child: Text("Thank you for accepting our Policies"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          MihSnackBar(
            child: Text("There was an error, please try again later"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return Container(
          color: Colors.black.withValues(alpha: 0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              MihPackageWindow(
                fullscreen: false,
                windowTitle: null,
                onWindowTapClose: null,
                windowBody: Column(
                  children: [
                    Icon(
                      Icons.policy,
                      size: 150,
                      color: MihColors.secondary(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome to the MIH App",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MihColors.secondary(),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "To keep using the MIH app, please take a moment to review and accept our Policies. Our agreements helps us keep things running smoothly and securely.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MihColors.secondary(),
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          MihButton(
                            onPressed: () {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                context
                                    .read<AboutMihProvider>()
                                    .setToolIndex(1);
                              });
                              context.goNamed("aboutMih",
                                  extra: mzansiProfileProvider.personalHome);
                            },
                            buttonColor: MihColors.orange(),
                            elevation: 10,
                            width: 300,
                            child: Text(
                              "Privacy Policy",
                              style: TextStyle(
                                color: MihColors.primary(),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MihButton(
                            onPressed: () {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                context
                                    .read<AboutMihProvider>()
                                    .setToolIndex(2);
                              });
                              context.goNamed("aboutMih",
                                  extra: mzansiProfileProvider.personalHome);
                            },
                            buttonColor: MihColors.yellow(),
                            elevation: 10,
                            width: 300,
                            child: Text(
                              "Terms of Service",
                              style: TextStyle(
                                color: MihColors.primary(),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          MihButton(
                            onPressed: () {
                              DateTime now = DateTime.now();
                              KenLogger.success("Date Time Now: $now");
                              createOrUpdateAccpetance(mzansiProfileProvider);
                            },
                            buttonColor: MihColors.green(),
                            elevation: 10,
                            width: 300,
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                color: MihColors.primary(),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
