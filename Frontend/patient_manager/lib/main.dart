import 'package:flutter/material.dart';
import 'package:patient_manager/router/routeGenerator.dart';

void main() {
  runApp(const MzanziInnovationHub());
}

class MzanziInnovationHub extends StatelessWidget {
  const MzanziInnovationHub({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MyFlutterAp',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
