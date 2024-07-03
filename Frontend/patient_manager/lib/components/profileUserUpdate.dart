import 'package:flutter/material.dart';
import 'package:patient_manager/components/myDropdownInput.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/appUser.dart';

class ProfileUserUpdate extends StatefulWidget {
  final AppUser signedInUser;
  //final String userEmail;
  const ProfileUserUpdate({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileUserUpdate> createState() => _ProfileUserUpdateState();
}

class _ProfileUserUpdateState extends State<ProfileUserUpdate> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    fnameController.text = widget.signedInUser.fname;
    lnameController.text = widget.signedInUser.lname;
    titleController.text = widget.signedInUser.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15.0),
        const Text(
          "Update User profile:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 15.0),
        MyTextField(
          controller: fnameController,
          hintText: "First Name",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10.0),
        MyTextField(
          controller: lnameController,
          hintText: "Last Name",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10.0),
        MyDropdownField(
          controller: titleController,
          signedInUser: widget.signedInUser,
          dropdownOptions: const <DropdownMenuEntry<String>>[
            DropdownMenuEntry(value: "Dr.", label: "Doctor"),
            DropdownMenuEntry(value: "Assistant", label: "Assistant"),
          ],
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: 500.0,
          height: 100.0,
          child: MyButton(
              onTap: () {
                if (fnameController.text == "") {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Field\\s'),
                        content: const Text(
                          'Please conplete all fields',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Disable'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              buttonText: "Update"),
        ),
      ],
    );
  }
}
