import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pwa_install/pwa_install.dart';
import '../mih_env/env.dart';
import '../../main.dart';
import 'package:supertokens_flutter/supertokens.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  AppEnviroment.setupEnv(Enviroment.prod);
  SuperTokens.init(
    apiDomain: AppEnviroment.baseApiUrl,
    apiBasePath: "/auth",
  );
  // setUrlStrategy(PathUrlStrategy());
  FlutterNativeSplash.remove();
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  runApp(const MzanziInnovationHub());
}
