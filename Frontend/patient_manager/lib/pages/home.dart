import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/components/myAppBar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: MyAppBar(
          barTitle: "Mzanzi Innovation Hub",
        ),
      ),
      body: HomeTileGrid(),
    );
  }
}
