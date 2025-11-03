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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    MihBannerAdProvider adProvider = context.read<MihBannerAdProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      adProvider.reset();
      adProvider.loadBannerAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MihBannerAdProvider>(
      builder: (context, bannerAdProvider, child) {
        if (!bannerAdProvider.isBannerAdLoaded) {
          return SizedBox();
        }
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
