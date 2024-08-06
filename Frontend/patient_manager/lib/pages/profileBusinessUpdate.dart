import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';

class ProfileBusinessUpdate extends StatefulWidget {
  final AppUser signedInUser;
  //final String userEmail;
  const ProfileBusinessUpdate({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileBusinessUpdate> createState() => _ProfileBusinessUpdateState();
}

class _ProfileBusinessUpdateState extends State<ProfileBusinessUpdate> {
  final FocusNode _focusNode = FocusNode();
  final tempController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Update Profile"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (event) async {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                //submitForm();
              }
            },
            child: Column(
              children: [
                const Text(
                  "Personal profile:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15.0),
                MyTextField(
                  controller: tempController,
                  hintText: "Username",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: tempController,
                  hintText: "First Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: tempController,
                  hintText: "Last Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Activate Business Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: MyButton(
                    buttonText: "Update",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      //submitForm();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
