import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/myAppBar.dart';
import 'package:http/http.dart' as http;
import '../objects/AppUser.dart';
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
  final docOfficeIdApiUrl = "http://localhost:80/docOffices/user/";
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
      throw Exception('failed to load patients');
    }
  }

  Future<void> updatePatientApiCall() async {
    print("Here1");
    //userEmail = getLoginUserEmail() as String;
    print(userEmail);
    print("Here2");
    await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    print(futureDocOfficeId.toString());
    print("Here3");
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
    print("Here4");
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/patient-manager', arguments: userEmail);
      String message =
          "${fnameController.text} ${lnameController.text} Successfully Updated";
      messagePopUp(message);
    } else {
      messagePopUp("error ${response.statusCode}");
    }
  }

  Future<void> deletePatientApiCall() async {
    print("Here1");
    //userEmail = getLoginUserEmail() as String;
    print(userEmail);
    print("Here2");
    await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    print("Office ID: ${futureDocOfficeId.toString()}");
    print("OPatient ID No: ${idController.text}");
    print("Here3");
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
    print("Here4");
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/patient-manager', arguments: userEmail);
      String message =
          "${fnameController.text} ${lnameController.text} Successfully Deleted";
      messagePopUp(message);
    } else {
      messagePopUp("error ${response.statusCode}");
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning),
                              Text("Warning"),
                            ],
                          ),
                          content: Text(
                              "You are trying to delete the patient ${fnameController.text} ${lnameController.text}.\n\n" +
                                  "Please note that this patient will be deleted permenantly and can not be retored\n\n" +
                                  "Would you like to delete patient?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                deletePatientApiCall();
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            )
                          ],
                        ),
                      );
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
                        updatePatientApiCall();
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
