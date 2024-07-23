import 'package:flutter/material.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:supertokens_flutter/supertokens.dart';

void main() async {
  AppEnviroment.setupEnv(Enviroment.prod);
  SuperTokens.init(
    apiDomain: AppEnviroment.baseApiUrl,
    apiBasePath: "/api/auth",
  );
  runApp(const MzanziInnovationHub());
}
