import 'package:flutter/material.dart';
import 'package:patient_manager/objects/appUser.dart';

class ProfileOfficeUpdate extends StatefulWidget {
  final AppUser signedInUser;
  //final String userEmail;
  const ProfileOfficeUpdate({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileOfficeUpdate> createState() => _ProfileOfficeUpdateState();
}

class _ProfileOfficeUpdateState extends State<ProfileOfficeUpdate> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Office profile: ${widget.signedInUser.email}"));
  }
}
