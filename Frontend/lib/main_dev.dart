import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart'
    if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_go_router.dart';
import 'package:pwa_install/pwa_install.dart';
import 'mih_config/mih_env.dart';
import 'package:supertokens_flutter/supertokens.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppEnviroment.setupEnv(Enviroment.dev);
  SuperTokens.init(
    apiDomain: AppEnviroment.baseApiUrl,
    apiBasePath: "/auth",
  );
  if (!kIsWeb) {
    const List<String> testDeviceIds = ['733d4c68-9b54-453a-9622-2df407310f40'];
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: testDeviceIds,
      ),
    );
    MobileAds.instance.initialize();
  } else {
    usePathUrlStrategy();
  }
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  final GoRouter appRouter = MihGoRouter().mihRouter;
  FlutterNativeSplash.remove();
  runApp(MzansiInnovationHub(
    router: appRouter,
  ));
}
