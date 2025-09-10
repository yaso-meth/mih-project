import 'dart:io';

import 'package:flutter/foundation.dart';

enum Enviroment { dev, prod }

//
abstract class AppEnviroment {
  static late String baseAppUrl;
  static late String baseApiUrl;
  static late String baseAiUrl;
  static late String baseFileUrl;
  static late String bannerAdUnitId;
  static late String whatsappAccessToken;
  static late String fingerPrintPluginKey;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;
  static setupEnv(Enviroment env) {
    _enviroment = env;
    switch (env) {
      case Enviroment.dev:
        {
          if (kIsWeb) {
            //================= Web Dev Urls =================
            baseAppUrl = "http://localhost:80";
            baseApiUrl = "http://localhost:8080";
            baseFileUrl = "http://localhost:9000";
            baseAiUrl = "http://localhost:11434";
            bannerAdUnitId = 'ca-app-pub-3940256099942544/2435281174';
            break;
          } else if (Platform.isAndroid) {
            //================= Android Dev Urls =================
            baseAppUrl = "http://10.0.2.2:80";
            baseApiUrl = "http://10.0.2.2:8080";
            baseFileUrl = "http://10.0.2.2:9000";
            baseAiUrl = "http://10.0.2.2:11434";
            bannerAdUnitId = 'ca-app-pub-3940256099942544/9214589741';
          } else {
            //================= Web & iOS Dev Urls =================
            baseAppUrl = "http://localhost:80";
            baseApiUrl = "http://localhost:8080";
            baseFileUrl = "http://localhost:9000";
            baseAiUrl = "http://localhost:11434";
            bannerAdUnitId = 'ca-app-pub-3940256099942544/2435281174';
            break;
          }
        }
      case Enviroment.prod:
        {
          baseAppUrl = "https://app.mzansi-innovation-hub.co.za";
          baseApiUrl = "https://api.mzansi-innovation-hub.co.za";
          baseFileUrl = "https://minio.mzansi-innovation-hub.co.za";
          baseAiUrl = "https://ai.mzansi-innovation-hub.co.za";
          if (kIsWeb) {
            // No banner ads on web, or use a placeholder/specific web ad unit
            bannerAdUnitId = ''; // Or a specific web ad unit ID if you have one
          } else if (Platform.isAndroid) {
            bannerAdUnitId =
                'ca-app-pub-4781880856775334/8868663088'; // Android
          } else if (Platform.isIOS) {
            // Use Platform.isIOS for clarity
            bannerAdUnitId = 'ca-app-pub-4781880856775334/6640324682'; // iOS
          } else {
            // Fallback for other platforms if necessary
            bannerAdUnitId = '';
          }
          // bannerAdUnitId = Platform.isAndroid
          //     ? 'ca-app-pub-4781880856775334/8868663088' // Android
          //     : 'ca-app-pub-4781880856775334/6640324682'; // iOS
          //fingerPrintPluginKey = 'h5X7a5j14iUZCobI1ZeX';
          break;
        }
    }
  }

  static String getEnv() {
    //_enviroment = env;
    switch (_enviroment) {
      case Enviroment.dev:
        {
          return "Dev";
        }
      case Enviroment.prod:
        {
          return "Prod";
        }
    }
  }
}
