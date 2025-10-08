import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:provider/provider.dart';

class MihBannerAd extends StatefulWidget {
  const MihBannerAd({super.key});

  @override
  State<MihBannerAd> createState() => _MihBannerAdState();
}

class _MihBannerAdState extends State<MihBannerAd> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MihBannerAdProvider>(
      builder: (context, bannerAdProvider, child) {
        return Column(
          children: [
            bannerAdProvider.bannerAd != null &&
                    bannerAdProvider.isBannerAdLoaded
                ? SizedBox(
                    width: bannerAdProvider.bannerAd!.size.width.toDouble(),
                    height: bannerAdProvider.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: bannerAdProvider.bannerAd!))
                : SizedBox(
                    child: Text(AppEnviroment.getEnv() == "Dev"
                        ? bannerAdProvider.errorMessage
                        : ""),
                  ),
          ],
        );
      },
    );
  }
}
