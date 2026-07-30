import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/about_mih_heading.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/call_to_action_buttons.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/founder_details.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/mih_social_links.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/mission_and_vission.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MihInfo extends StatefulWidget {
  const MihInfo({super.key});

  @override
  State<MihInfo> createState() => _MihInfoState();
}

class _MihInfoState extends State<MihInfo> {
  void shareMIHLink(BuildContext context, String message, String link) {
    String shareText = "$message: $link";
    SharePlus.instance.share(
      ShareParams(text: shareText),
    );
  }

  Widget displayBusinessCount(AboutMihProvider aboutProvider) {
    return Skeletonizer(
      enabled: aboutProvider.businessCount == null,
      enableSwitchAnimation: true,
      effect: ShimmerEffect(
        baseColor: MihColors.highlight(),
        highlightColor: MihColors.secondary(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Text(
              "${aboutProvider.businessCount}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Businesses",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget displayUserCount(AboutMihProvider aboutProvider) {
    return Skeletonizer(
      enabled: aboutProvider.userCount == null,
      enableSwitchAnimation: true,
      effect: ShimmerEffect(
        baseColor: MihColors.highlight(),
        highlightColor: MihColors.secondary(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: Text(
              "${aboutProvider.userCount}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "People",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget mihDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 25,
      ),
      child: Divider(
        thickness: 1,
        color: MihColors.grey(),
      ),
    );
  }

  Widget communityCounter(AboutMihProvider aboutProvider) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 25,
          runSpacing: 10,
          children: [
            displayUserCount(aboutProvider),
            displayBusinessCount(aboutProvider),
          ],
        ),
        Text(
          "The MIH Community",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (
      BuildContext context,
      AboutMihProvider aboutProvider,
      Widget? child,
    ) {
      return MihPackageToolBody(
        backgroundColor: MihColors.primary(),
        borderOn: false,
        bodyItem: getBody(aboutProvider),
      );
    });
  }

  Widget getBody(AboutMihProvider aboutProvider) {
    return Stack(
      children: [
        MihSingleChildScroll(
          scrollbarOn: true,
          child: Column(
            children: [
              AboutMihHeading(),
              communityCounter(aboutProvider),
              CallToActionButtons(),
              mihDivider(),
              MissionAndVission(),
              mihDivider(),
              FounderDetails(),
              mihDivider(),
              MihSocialLinks(),
            ],
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: MihFloatingMenu(
            icon: Icons.share,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.android,
                  color: MihColors.primary(),
                ),
                label: "Android",
                labelBackgroundColor: MihColors.green(),
                labelStyle: TextStyle(
                  color: MihColors.primary(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.green(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the Play Store",
                    "https://play.google.com/store/apps/details?id=za.co.mzansiinnovationhub.mih",
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.apple,
                  color: MihColors.primary(),
                ),
                label: "iOS",
                labelBackgroundColor: MihColors.green(),
                labelStyle: TextStyle(
                  color: MihColors.primary(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.green(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the App Store",
                    "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.store,
                  color: MihColors.primary(),
                ),
                label: "Huawei",
                labelBackgroundColor: MihColors.green(),
                labelStyle: TextStyle(
                  color: MihColors.primary(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.green(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the App Gallery",
                    "https://appgallery.huawei.com/app/C113315335?pkgName=za.co.mzansiinnovationhub.mih",
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.vpn_lock,
                  color: MihColors.primary(),
                ),
                label: "Web",
                labelBackgroundColor: MihColors.green(),
                labelStyle: TextStyle(
                  color: MihColors.primary(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.green(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the Web",
                    "https://app.mzansi-innovation-hub.co.za/",
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
