import 'package:flutter/material.dart';
import 'package:patient_manager/components/myAppBar.dart';

class PatientManager extends StatefulWidget {
  const PatientManager({super.key});

  @override
  State<PatientManager> createState() => _PatientManagerState();
}

class _PatientManagerState extends State<PatientManager> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: MyAppBar(
          barTitle: "Mzanzi Innovation Hub",
        ),
      ),
    );
  }
}
