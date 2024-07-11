enum Enviroment { dev, prod }

abstract class AppEnviroment {
  static late String baseApiUrl;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;
  static setupEnv(Enviroment env) {
    _enviroment = env;
    switch (env) {
      case Enviroment.dev:
        {
          baseApiUrl = "http://localhost";
          break;
        }
      case Enviroment.prod:
        {
          baseApiUrl = "api";
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
