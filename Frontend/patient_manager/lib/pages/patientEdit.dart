import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/myAppBar.dart';
import 'package:http/http.dart' as http;
import '../objects/patients.dart';

class EditPatient extends StatefulWidget {
  final Patient selectedPatient;

  const EditPatient({
    super.key,
    required this.selectedPatient,
  });

  @override
  State<EditPatient> createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatient> {
  var idController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final medNoController = TextEditingController();
  final medNameController = TextEditingController();
  final medSchemeController = TextEditingController();
  final addressController = TextEditingController();
  final docOfficeIdApiUrl = "http://localhost:80/users/profile/";
  final apiUrlEdit = "http://localhost:80/patients/update/";
  final apiUrlDelete = "http://localhost:80/patients/delete/";
  late int futureDocOfficeId;
  late String userEmail;

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

  Future<void> updatePatientApiCall() async {
    //print("Here1");
    //userEmail = getLoginUserEmail() as String;
    //print(userEmail);
    //print("Here2");
    await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    //print(futureDocOfficeId.toString());
    //print("Here3");
    var response = await http.put(
      Uri.parse(apiUrlEdit),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": idController.text,
        "first_name": fnameController.text,
        "last_name": lnameController.text,
        "email": emailController.text,
        "cell_no": cellController.text,
        "medical_aid_name": medNameController.text,
        "medical_aid_no": medNoController.text,
        "medical_aid_scheme": medSchemeController.text,
        "address": addressController.text,
        "doc_office_id": futureDocOfficeId,
      }),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/patient-manager', arguments: userEmail);
      String message =
          "${fnameController.text} ${lnameController.text} Successfully Updated";
      messagePopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> deletePatientApiCall() async {
    //print("Here1");
    //userEmail = getLoginUserEmail() as String;
    //print(userEmail);
    //print("Here2");
    await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    //print("Office ID: ${futureDocOfficeId.toString()}");
    //print("OPatient ID No: ${idController.text}");
    //print("Here3");
    var response = await http.delete(
      Uri.parse(apiUrlDelete),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": idController.text,
        "doc_office_id": futureDocOfficeId,
      }),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/patient-manager', arguments: userEmail);
      String message =
          "${fnameController.text} ${lnameController.text} Successfully Deleted";
      messagePopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> getLoginUserEmail() async {
    userEmail =
        (await Supabase.instance.client.auth.currentUser?.email.toString())!;
    //print(userEmail);
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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void deletePatientPopUp() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 500.0,
              height: 475.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.blueAccent, width: 5.0),
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Are you sure you want to delete this?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "This action is permanent! Deleting ${fnameController.text} ${lnameController.text} will remove him\\her from your account. You won't be able to recover it once it's gone.",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Here's what you'll be deleting:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: 450,
                      child: Text(
                        "1) Patient Profile Information.\n2) Patient Notes\n3) Patient Files.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 300,
                      height: 100,
                      child: MyButton(
                          onTap: deletePatientApiCall, buttonText: "Delete"))
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isFieldsFilled() {
    if (idController.text.isEmpty ||
        fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        cellController.text.isEmpty ||
        emailController.text.isEmpty ||
        medNoController.text.isEmpty ||
        medNameController.text.isEmpty ||
        medSchemeController.text.isEmpty ||
        addressController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    getLoginUserEmail();
    setState(() {
      idController.value = TextEditingValue(text: widget.selectedPatient.id_no);
      fnameController.value =
          TextEditingValue(text: widget.selectedPatient.first_name);
      lnameController.value =
          TextEditingValue(text: widget.selectedPatient.last_name);
      cellController.value =
          TextEditingValue(text: widget.selectedPatient.cell_no);
      emailController.value =
          TextEditingValue(text: widget.selectedPatient.email);
      medNameController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_name);
      medNoController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_no);
      medSchemeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_scheme);
      addressController.value =
          TextEditingValue(text: widget.selectedPatient.address);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Edit Patient"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  IconButton(
                    icon: const Icon(Icons.delete),
                    alignment: Alignment.topRight,
                    onPressed: () {
                      deletePatientPopUp();
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: idController,
                      hintText: "13 digit ID Number or Passport",
                      editable: false,
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
                    child: MyTextField(
                      controller: medNoController,
                      hintText: "Medical Aid No.",
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
                      controller: medNameController,
                      hintText: "Medical Aid Name",
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
                      controller: medSchemeController,
                      hintText: "Medical Aid Scheme",
                      editable: true,
                      required: true,
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
                          updatePatientApiCall();
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
                      buttonText: "Update",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
