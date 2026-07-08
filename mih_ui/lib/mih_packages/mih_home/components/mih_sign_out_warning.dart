import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihSignOutWarning extends StatefulWidget {
  const MihSignOutWarning({super.key});

  @override
  State<MihSignOutWarning> createState() => _MihSignOutWarningState();
}

class _MihSignOutWarningState extends State<MihSignOutWarning> {
  @override
  Widget build(BuildContext context) {
    return MihPackageWindow(
      fullscreen: false,
      backgroundColor: MihColors.secondary(),
      windowTitle: null,
      onWindowTapClose: null,
      windowBody: Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 150,
            color: MihColors.primary(),
          ),
          Center(
            child: Text(
              "Are You Sure?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MihColors.primary(),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Signing out clears your local app data. If any of your recent offline changes or updates haven't finished syncing to the MIH cloud, they will be permanently lost.\n\nPlease ensure you are connected to the internet and fully synced before signing out.",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              children: [
                MihButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  buttonColor: MihColors.green(),
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.primary(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MihButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  buttonColor: MihColors.red(),
                  width: 300,
                  child: Text(
                    "Sign Out",
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
        ],
      ),
    );
  }
}
