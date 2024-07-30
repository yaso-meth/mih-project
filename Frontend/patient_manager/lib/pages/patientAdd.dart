import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/myDropdownInput.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import '../components/mihAppBar.dart';
import 'package:supertokens_flutter/http.dart' as http;

class AddPatient extends StatefulWidget {
  final AppUser signedInUser;

  const AddPatient({
    super.key,
    required this.signedInUser,
  });

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final idController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final medNoController = TextEditingController();
  final medNameController = TextEditingController();
  final medSchemeController = TextEditingController();
  final addressController = TextEditingController();
  final medAidController = TextEditingController();
  final medMainMemController = TextEditingController();
  final medAidCodeController = TextEditingController();

  final baseAPI = AppEnviroment.baseApiUrl;
  late int futureDocOfficeId;
  late bool medRequired;

  bool isFieldsFilled() {
    if (medRequired) {
      if (idController.text.isEmpty ||
          fnameController.text.isEmpty ||
          lnameController.text.isEmpty ||
          cellController.text.isEmpty ||
          emailController.text.isEmpty ||
          medNoController.text.isEmpty ||
          medNameController.text.isEmpty ||
          medSchemeController.text.isEmpty ||
          addressController.text.isEmpty ||
          medAidController.text.isEmpty ||
          medMainMemController.text.isEmpty ||
          medAidCodeController.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      if (idController.text.isEmpty ||
          fnameController.text.isEmpty ||
          lnameController.text.isEmpty ||
          cellController.text.isEmpty ||
          emailController.text.isEmpty ||
          addressController.text.isEmpty ||
          medAidController.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
  }

  Future<void> addPatientAPICall() async {
    var response = await http.post(
      Uri.parse("$baseAPI/patients/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": idController.text,
        "first_name": fnameController.text,
        "last_name": lnameController.text,
        "email": emailController.text,
        "cell_no": cellController.text,
        "medical_aid": medAidController.text,
        "medical_aid_main_member": medMainMemController.text,
        "medical_aid_no": medNoController.text,
        "medical_aid_code": medAidCodeController.text,
        "medical_aid_name": medNameController.text,
        "medical_aid_scheme": medSchemeController.text,
        "address": addressController.text,
        "app_id": widget.signedInUser.app_id,
      }),
    );
    if (response.statusCode == 201) {
      Navigator.pushNamed(context, '/patient-manager/patient',
          arguments: widget.signedInUser);
      String message =
          "${fnameController.text} ${lnameController.text} patient profiole has been successfully added!\n";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void messagePopUp(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MySuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  void isRequired() {
    //print("listerner triggered");
    if (medAidController.text == "Yes") {
      setState(() {
        medRequired = true;
      });
    } else {
      setState(() {
        medRequired = false;
      });
    }
  }

  Widget displayForm() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Personal Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            const SizedBox(height: 10.0),
            MyTextField(
              controller: idController,
              hintText: "13 digit ID Number or Passport",
              editable: true,
              required: true,
            ),

            const SizedBox(height: 10.0),
            MyTextField(
              controller: fnameController,
              hintText: "First Name",
              editable: false,
              required: true,
            ),

            const SizedBox(height: 10.0),
            MyTextField(
              controller: lnameController,
              hintText: "Last Name",
              editable: false,
              required: true,
            ),

            const SizedBox(height: 10.0),

            MyTextField(
              controller: cellController,
              hintText: "Cell Number",
              editable: true,
              required: true,
            ),

            const SizedBox(height: 10.0),

            MyTextField(
              controller: emailController,
              hintText: "Email",
              editable: false,
              required: true,
            ),

            const SizedBox(height: 10.0),

            MyTextField(
              controller: addressController,
              hintText: "Address",
              editable: true,
              required: true,
            ),

            const SizedBox(height: 15.0),
            Text(
              "Medical Aid Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            const SizedBox(height: 10.0),

            MyDropdownField(
              controller: medAidController,
              hintText: "Medical Aid",
              editable: true,
              onSelect: (_) {
                isRequired();
              },
              required: true,
              dropdownOptions: const ["Yes", "No"],
            ),

            const SizedBox(height: 10.0),
            MyDropdownField(
              controller: medMainMemController,
              hintText: "Main Member",
              editable: medRequired,
              required: medRequired,
              dropdownOptions: const ["Yes", "No"],
            ),

            const SizedBox(height: 10.0),
            MyTextField(
              controller: medNoController,
              hintText: "Medical Aid No.",
              editable: medRequired,
              required: medRequired,
            ),

            const SizedBox(height: 10.0),

            MyTextField(
              controller: medAidCodeController,
              hintText: "Medical Aid Code",
              editable: medRequired,
              required: medRequired,
            ),

            const SizedBox(height: 10.0),

            MyTextField(
              controller: medNameController,
              hintText: "Medical Aid Name",
              editable: medRequired,
              required: medRequired,
            ),

            const SizedBox(height: 10.0),

            MyTextField(
              controller: medSchemeController,
              hintText: "Medical Aid Scheme",
              editable: medRequired,
              required: medRequired,
            ),

            //const SizedBox(height: 10.0),

            SizedBox(
              width: 450.0,
              height: 100.0,
              child: MyButton(
                onTap: () {
                  if (isFieldsFilled()) {
                    addPatientAPICall();
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const MyErrorMessage(errorType: "Input Error");
                      },
                    );
                  }
                },
                buttonText: "Add",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    medAidController.addListener(isRequired);
    setState(() {
      fnameController.text = widget.signedInUser.fname;
      lnameController.text = widget.signedInUser.lname;
      emailController.text = widget.signedInUser.email;
      medAidController.text = "No";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Add Patient"),
      body: displayForm(),
    );
  }
}
