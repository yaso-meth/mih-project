import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/profileOfficeUpdate.dart';
import 'package:patient_manager/components/profileUserUpdate.dart';
import 'package:patient_manager/objects/appUser.dart';

class ProfileUpdate extends StatefulWidget {
  final AppUser signedInUser;
  //final String userEmail;
  const ProfileUpdate({
    super.key,
    //required this.userEmail,
    required this.signedInUser,
  });

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      //Center(child: Text("User profile")),
      ProfileUserUpdate(
        signedInUser: widget.signedInUser,
      ),
      ProfileOfficeUpdate(
        signedInUser: widget.signedInUser,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Update Profile"),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 5.0),
        child: GNav(
          //hoverColor: Colors.lightBlueAccent,
          iconSize: 35.0,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.blueAccent,
          gap: 20,
          //padding: EdgeInsets.all(15),
          tabs: const [
            GButton(
              icon: Icons.perm_identity,
              text: "User Profile",
            ),
            GButton(
              icon: Icons.business,
              text: "Office Profile",
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
