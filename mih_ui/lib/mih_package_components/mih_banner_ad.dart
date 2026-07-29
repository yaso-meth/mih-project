import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_banner_ad_provider.dart';
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
    if (!adProvider.isBannerAdLoaded) {
      adProvider.loadBannerAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MihBannerAdProvider>(
      builder: (context, bannerAdProvider, child) {
        if (!bannerAdProvider.isBannerAdLoaded ||
            bannerAdProvider.bannerAd == null) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          width: bannerAdProvider.bannerAd!.size.width.toDouble(),
          height: bannerAdProvider.bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: bannerAdProvider.bannerAd!),
        );
      },
    );
  }
}
