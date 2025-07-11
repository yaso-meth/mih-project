import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';

class MihBannerAd extends StatefulWidget {
  const MihBannerAd({super.key});

  @override
  State<MihBannerAd> createState() => _MihBannerAdState();
}

class _MihBannerAdState extends State<MihBannerAd> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  final adUnitId = AppEnviroment.bannerAdUnitId;
  String errorMessage = '';

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          setState(() {
            errorMessage =
                'Failed to load ad- Message: ${err.message} Code :${err.code}';
          });
          ad.dispose(); // Dispose the ad to free resources
        },
        onAdOpened: (Ad ad) => debugPrint('$ad opened.'),
        onAdClosed: (Ad ad) => debugPrint('$ad closed.'),
        onAdImpression: (Ad ad) => debugPrint('$ad impression.'),
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Dispose the ad when the widget is removed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _bannerAd != null && _isBannerAdLoaded
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!))
            : SizedBox(
                child:
                    Text(AppEnviroment.getEnv() == "Dev" ? errorMessage : ""),
              ),
      ],
    );
  }
}
