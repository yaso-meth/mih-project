import 'package:flutter/material.dart';
import 'package:patient_manager/router/routeGenerator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://stzluvsyhbwtfbztarmu.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0emx1dnN5aGJ3dGZienRhcm11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIwNzUyMTMsImV4cCI6MjAyNzY1MTIxM30.a7VHlk63JJcAotvsqtoqiKwjNK4EbnNgKilAqt1iRio",
  );
  runApp(const MzanziInnovationHub());
}

final client = Supabase.instance.client;

class MzanziInnovationHub extends StatelessWidget {
  const MzanziInnovationHub({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mzansi Innovation Hub',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
