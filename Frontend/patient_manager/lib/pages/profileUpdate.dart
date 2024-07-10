import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/profileOfficeUpdate.dart';
import 'package:patient_manager/components/profileUserUpdate.dart';
import 'package:patient_manager/main.dart';
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
      bottomNavigationBar: GNav(
        //hoverColor: Colors.lightBlueAccent,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        iconSize: 35.0,
        activeColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        tabBackgroundColor:
            MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        //gap: 20,
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
    );
  }
}
