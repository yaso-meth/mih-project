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
          baseApiUrl = "http://localhost:81";
          baseFileUrl = "http://localhost:9000";
          break;
        }
      case Enviroment.prod:
        {
          baseApiUrl = "http://MIH_API_Hub:81";
          baseFileUrl = "http://MIH_Minio:9000";
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
