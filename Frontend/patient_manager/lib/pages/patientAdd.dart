import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import '../components/myAppBar.dart';
import 'package:http/http.dart' as http;
import '../objects/AppUser.dart';

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
  final docOfficeIdApiUrl = "http://localhost:80/docOffices/user/";
  final apiUrl = "http://localhost:80/patients/insert/";
  late int futureDocOfficeId;

  Future getOfficeIdByUser(String endpoint) async {
    print("here1.1");
    final response = await http.get(Uri.parse(endpoint));
    print("here1.2");
    if (response.statusCode == 200) {
      print("here1.3");
      String body = response.body;
      print(body);
      print("here1.4");
      var decodedData = jsonDecode(body);
      print("here1.5");
      AppUser u = AppUser.fromJson(decodedData as Map<String, dynamic>);
      print("here1.6");
      setState(() {
        futureDocOfficeId = u.docOffice_id;
        //print(futureDocOfficeId);
      });
    } else {
      throw Exception('failed to load patients');
    }
  }

  Future<void> addPatientAPICall() async {
    print("here1");
    await getOfficeIdByUser(docOfficeIdApiUrl + widget.userEmail);
    print(futureDocOfficeId.toString());
    print("here2");
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
        "medical_aid_name": medNameController.text,
        "medical_aid_no": medNoController.text,
        "medical_aid_scheme": medSchemeController.text,
        "address": addressController.text,
        "doc_office_id": futureDocOfficeId,
      }),
    );
    print("here3");
    if (response.statusCode == 201) {
      Navigator.of(context)
          .pushNamed('/patient-manager', arguments: widget.userEmail);
      messagePopUp(fnameController.text +
          " " +
          lnameController.text +
          " Successfully added");
    } else {
      messagePopUp("error");
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Add Patient"),
      body: Padding(
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
                        hintText: "13 digit ID Number or Passport"),
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
                      onTap: addPatientAPICall,
                      buttonText: "Add",
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
