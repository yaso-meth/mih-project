import 'package:flutter/material.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/homeAppDrawer.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
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
      //print("emai not null");
      useremail = res.user!.email!;
      //print("Home Page: $useremail");
    }
  }

  String getEmail() {
    return useremail;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserEmail(),
      builder: (contexts, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: const MyAppBar(barTitle: "Mzansi Innovation Hub"),
            drawer: HomeAppDrawer(userEmail: useremail),
            body: HomeTileGrid(
              userEmail: useremail,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

    // Scaffold(
    //   appBar: MyAppBar(barTitle: "Mzanzi Innovation Hub"),
    //   body: HomeTileGrid(),
    //   drawer: FutureBuilder(
    //     future: getUserEmail(),
    //     builder: (contexts, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return MyAppDrawer(drawerTitle: useremail);
    //       } else {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //     },
    //   ),
    // );
  }
}
