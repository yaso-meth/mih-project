import 'package:flutter/material.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/myAppDrawer.dart';
import 'package:patient_manager/main.dart';

class PatientManager extends StatefulWidget {
  const PatientManager({super.key});

  @override
  State<PatientManager> createState() => _PatientManagerState();
}

class _PatientManagerState extends State<PatientManager> {
  String useremail = "";

  Future<void> getUserEmail() async {
    final res = await client.auth.getUser();
    if (res.user!.email != null) {
      //print("emai not null");
      useremail = res.user!.email!;
      //print(useremail);
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
            appBar: const MyAppBar(barTitle: "Patient Manager"),
            body: Center(child: Text(useremail)),
            drawer: MyAppDrawer(drawerTitle: useremail),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
