import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/myAppDrawer.dart';
import 'package:patient_manager/main.dart';

class Home extends StatefulWidget {
  //final String userEmail;
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String useremail = "";

  Future<void> getUserEmail() async {
    final res = await client.auth.getUser();
    if (res.user!.email != null) {
      print("emai not null");
      useremail = res.user!.email!;
      print(useremail);
    }
  }

  String getEmail() {
    return useremail;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: MyAppBar(barTitle: "Mzanzi Innovation Hub"),
              body: HomeTileGrid(),
              drawer: MyAppDrawer(drawerTitle: useremail),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
