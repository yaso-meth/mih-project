import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:supertokens_flutter/supertokens.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  AppEnviroment.setupEnv(Enviroment.dev);
  SuperTokens.init(
    apiDomain: AppEnviroment.baseApiUrl,
    apiBasePath: "/auth",
  );
  FlutterNativeSplash.remove();
  runApp(const MzanziInnovationHub());
}
