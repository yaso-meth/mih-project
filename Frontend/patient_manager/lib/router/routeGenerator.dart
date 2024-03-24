// ignore: file_names
import 'package:flutter/material.dart';
import 'package:patient_manager/pages/home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Home());
      // case '/business':
      //   return MaterialPageRoute(builder: (_) => const Business());
      // case '/businessList':
      //   return MaterialPageRoute(builder: (_) => const BusinessList());
      // //case '/signIn':
      // //  return MaterialPageRoute(builder: (_) => SignIn());
      // case '/auth':
      //   return MaterialPageRoute(builder: (_) => const AuthPage());
    }
    throw '';
  }
}
