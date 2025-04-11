enum Enviroment { dev, prod }

//
abstract class AppEnviroment {
  static late String baseApiUrl;
  static late String baseAiUrl;
  static late String baseFileUrl;
  static late String whatsappAccessToken;
  static late String fingerPrintPluginKey;
  static late Enviroment _enviroment;
  static Enviroment get enviroment => _enviroment;
  static setupEnv(Enviroment env) {
    _enviroment = env;
    switch (env) {
      case Enviroment.dev:
        {
          //================= Android Dev Urls =================
          baseApiUrl = "http://10.0.2.2:8080";
          baseFileUrl = "http://10.0.2.2:9000";
          baseAiUrl = "http://10.0.2.2:11434";
          //================= Web Dev Urls =================
          // baseApiUrl = "http://localhost:8080";
          // baseFileUrl = "http://localhost:9000";
          // baseAiUrl = "http://localhost:11434";
          whatsappAccessToken =
              "EAAPINXuNFdYBOzBjTcvZA2iPXEHbHRF9uNXyP3ihkPRUcBqKNru5g9NKRRKkFaiaITEzO3BMo6CjdUmlDH4qYTW2mzDrZB4Q21ZCEZBgECZCu27vfaOXJZCYQLNxwoXkrZBRYv8ZAP37f69r3z9JxLQxdxn9gwqA3oNZAlBBRapJQzxOr6pZBTdI3bbjbu17ZBIwRcF4JCqPDCNLEZCI3bmHwEd2i2niNMYZD";
          //fingerPrintPluginKey = 'h5X7a5j14iUZCobI1ZeX';
          break;
        }
      case Enviroment.prod:
        {
          baseApiUrl = "https://api.mzansi-innovation-hub.co.za";
          baseFileUrl = "https://minio.mzansi-innovation-hub.co.za";
          baseAiUrl = "https://ai.mzansi-innovation-hub.co.za";
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
