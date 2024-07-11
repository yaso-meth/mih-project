import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/components/homeTileGrid.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/homeAppDrawer.dart';

class Home extends StatefulWidget {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            // floatingActionButton: Padding(
            //   padding: const EdgeInsets.only(top: 65, right: 5),
            //   child: FloatingActionButton.extended(
            //     label: const Text(
            //       "Test Pop Up",
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     //backgroundColor: Colors.blueAccent,
            //     onPressed: () {
            //       showDatePicker(
            //         context: context,
            //         initialDate: DateTime.now(),
            //         firstDate: DateTime(2000),
            //         lastDate: DateTime(2100),
            //       );
            //       // showDialog(
            //       //   context: context,
            //       //   builder: (context) =>
            //       //       const MyErrorMessage(errorType: "Input Error"),
            //       // );
            //     },
            //     icon: const Icon(
            //       Icons.warning,
            //       //color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            //     ),
            //   ),
          );
          //);
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
