enum Enviroment { dev, prod }

//
abstract class AppEnviroment {
  static late String baseApiUrl;
  static late String baseFileUrl;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;
  static setupEnv(Enviroment env) {
    _enviroment = env;
    switch (env) {
      case Enviroment.dev:
        {
          baseApiUrl = "http://localhost:8080";
          baseFileUrl = "http://localhost:9000";
          break;
        }
      case Enviroment.prod:
        {
          baseApiUrl = "https://api.mzansi-innovation-hub.co.za/";
          baseFileUrl = "https://mzansi-innovation-hub.co.za/files";
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
