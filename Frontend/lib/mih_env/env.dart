enum Enviroment { dev, prod }

//
abstract class AppEnviroment {
  static late String baseApiUrl;
  static late String baseFileUrl;
  static late String fingerPrintPluginKey;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;
  static setupEnv(Enviroment env) {
    _enviroment = env;
    switch (env) {
      case Enviroment.dev:
        {
          baseApiUrl = "http://localhost:8080";
          baseFileUrl = "http://localhost:9000";
          //fingerPrintPluginKey = 'h5X7a5j14iUZCobI1ZeX';
          break;
        }
      case Enviroment.prod:
        {
          baseApiUrl = "https://api.mzansi-innovation-hub.co.za";
          baseFileUrl = "https://minio.mzansi-innovation-hub.co.za";
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
