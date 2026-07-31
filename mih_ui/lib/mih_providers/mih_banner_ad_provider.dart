import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';

class MihBannerAdProvider extends ChangeNotifier {
  BannerAd? bannerAd;
  final adUnitId = AppEnviroment.bannerAdUnitId;
  bool isBannerAdLoaded = false;
  String errorMessage = '';

  MihBannerAdProvider({
    this.bannerAd,
    this.isBannerAdLoaded = false,
    this.errorMessage = '',
  });

  void reset() {
    bannerAd = null;
    isBannerAdLoaded = false;
    errorMessage = "";
    notifyListeners();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  void loadBannerAd() {
    if (isBannerAdLoaded && bannerAd != null) return;

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      bannerAd?.dispose();
      bannerAd = null;

      bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            isBannerAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            errorMessage =
                'Failed to load ad - Message: ${err.message} Code :${err.code}';
            ad.dispose();
            isBannerAdLoaded = false;
            bannerAd = null;
            notifyListeners();
          },
          onAdOpened: (Ad ad) => debugPrint('$ad opened.'),
          onAdClosed: (Ad ad) => debugPrint('$ad closed.'),
          onAdImpression: (Ad ad) => debugPrint('$ad impression.'),
        ),
      );
      bannerAd!.load();
    }
  }
}
