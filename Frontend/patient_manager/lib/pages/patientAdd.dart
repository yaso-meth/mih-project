import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/myDropdownInput.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/appUser.dart';
import '../components/myAppBar.dart';
import 'package:http/http.dart' as http;

class AddPatient extends StatefulWidget {
  final String userEmail;

  const AddPatient({
    super.key,
    required this.userEmail,
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

  final docOfficeIdApiUrl = "http://localhost:80/users/profile/";
  final apiUrl = "http://localhost:80/patients/insert/";
  late int futureDocOfficeId;
  late bool medRequired;

  Future getOfficeIdByUser(String endpoint) async {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      String body = response.body;
      var decodedData = jsonDecode(body);
      AppUser u = AppUser.fromJson(decodedData as Map<String, dynamic>);
      setState(() {
        futureDocOfficeId = u.docOffice_id;
        //print(futureDocOfficeId);
      });
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load patients');
    }
  }

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
    await getOfficeIdByUser(docOfficeIdApiUrl + widget.userEmail);
    print(futureDocOfficeId.toString());
    var response = await http.post(
      Uri.parse(apiUrl),
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
        "doc_office_id": futureDocOfficeId,
      }),
    );
    if (response.statusCode == 201) {
      Navigator.of(context)
          .pushNamed('/patient-manager', arguments: widget.userEmail);
      String message =
          "${fnameController.text} ${lnameController.text} has been successfully added to the Patient Manager! You can now view their details, add notes & documents, and update their information.";
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
            const Text(
              "Personal Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                //color: Colors.blueAccent,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: idController,
                    hintText: "13 digit ID Number or Passport",
                    editable: true,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: fnameController,
                    hintText: "First Name",
                    editable: true,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: lnameController,
                    hintText: "Last Name",
                    editable: true,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: cellController,
                    hintText: "Cell Number",
                    editable: true,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    editable: true,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: addressController,
                    hintText: "Address",
                    editable: true,
                    required: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            const Text(
              "Medical Aid Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                //color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyDropdownField(
                    controller: medAidController,
                    hintText: "Has Medical Aid",
                    //editable: true,
                    onSelect: (_) {
                      isRequired();
                    },
                    required: true,
                    dropdownOptions: const ["Yes", "No"],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyDropdownField(
                    controller: medMainMemController,
                    hintText: "Main Member",
                    //editable: true,
                    required: medRequired,
                    dropdownOptions: const ["Yes", "No"],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: medNoController,
                    hintText: "Medical Aid No.",
                    editable: true,
                    required: medRequired,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: medAidCodeController,
                    hintText: "Medical Aid Code",
                    editable: true,
                    required: medRequired,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: medNameController,
                    hintText: "Medical Aid Name",
                    editable: true,
                    required: medRequired,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: medSchemeController,
                    hintText: "Medical Aid Scheme",
                    editable: true,
                    required: medRequired,
                  ),
                ),
              ],
            ),
            //const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: MyButton(
                    onTap: () {
                      if (isFieldsFilled()) {
                        addPatientAPICall();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const MyErrorMessage(
                                errorType: "Input Error");
                          },
                        );
                      }
                    },
                    buttonText: "Add",
                    buttonColor: Colors.blueAccent,
                    textColor: Colors.white,
                  ),
                ),
              ],
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
      medAidController.text = "No";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Add Patient"),
      body: displayForm(),
    );
  }
}
