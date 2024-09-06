import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:patient_manager/components/builders/buildFilesList.dart';
import 'package:patient_manager/components/inputsAndButtons/mihFileInput.dart';
import 'package:patient_manager/components/medCertInput.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
import 'package:patient_manager/components/prescipInput.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:patient_manager/objects/files.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import 'package:supertokens_flutter/supertokens.dart';

import '../objects/patients.dart';

class PatientFiles extends StatefulWidget {
  final int patientIndex;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;

  const PatientFiles({
    super.key,
    required this.patientIndex,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.type,
  });

  @override
  State<PatientFiles> createState() => _PatientFilesState();
}

class _PatientFilesState extends State<PatientFiles> {
  String endpointFiles = "${AppEnviroment.baseApiUrl}/files/patients/";
  String endpointUser = "${AppEnviroment.baseApiUrl}/users/profile/";
  String endpointGenFiles =
      "${AppEnviroment.baseApiUrl}/files/generate/med-cert/";
  String endpointFileUpload = "${AppEnviroment.baseApiUrl}/files/upload/file/";
  String endpointInsertFiles = "${AppEnviroment.baseApiUrl}/files/insert/";

  final startDateController = TextEditingController();
  final endDateTextController = TextEditingController();
  final retDateTextController = TextEditingController();
  final selectedFileController = TextEditingController();
  final medicineController = TextEditingController();
  final quantityController = TextEditingController();
  final dosageController = TextEditingController();
  final timesDailyController = TextEditingController();
  final noDaysController = TextEditingController();
  final noRepeatsController = TextEditingController();
  final outputController = TextEditingController();

  late Future<List<PFile>> futueFiles;
  late String userEmail = "";
  late PlatformFile selected;
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> generateMedCert() async {
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    var response1 = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/generate/med-cert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": widget.selectedPatient.app_id,
        "fullName":
            "${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}",
        "id_no": widget.selectedPatient.id_no,
        "docfname":
            "DR. ${widget.signedInUser.fname} ${widget.signedInUser.lname}",
        "startDate": startDateController.text,
        "busName": widget.business!.Name,
        "busAddr": "*TO BE ADDED IN THE FUTURE*",
        "busNo": widget.business!.contact_no,
        "busEmail": widget.business!.bus_email,
        "endDate": endDateTextController.text,
        "returnDate": retDateTextController.text,
        "logo_path": widget.business!.logo_path,
        "sig_path": widget.businessUser!.sig_path,
      }),
    );
    //print(response1.statusCode);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String fileName =
        "Med-Cert-${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}-${date.toString().substring(0, 10)}.pdf";
    if (response1.statusCode == 200) {
      var response2 = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/files/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path":
              "${widget.selectedPatient.app_id}/patient_files/$fileName",
          "file_name": fileName,
          "app_id": widget.selectedPatient.app_id
        }),
      );
      //print(response2.statusCode);
      if (response2.statusCode == 201) {
        setState(() {
          startDateController.clear();
          endDateTextController.clear();
          retDateTextController.clear();
          futueFiles = fetchFiles();
        });
        // end loading circle
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        String message =
            "The medical certificate $fileName has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> uploadSelectedFile(PlatformFile file) async {
    //var strem = new http.ByteStream.fromBytes(file.bytes.)
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    var token = await SuperTokens.getAccessToken();
    //print(t);
    //print("here1");
    var request = http2.MultipartRequest(
        'POST', Uri.parse("${AppEnviroment.baseApiUrl}/minio/upload/file/"));
    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['app_id'] = widget.selectedPatient.app_id;
    request.fields['folder'] = "patient_files";
    request.files.add(await http2.MultipartFile.fromBytes('file', file.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    //print("here2");
    var response1 = await request.send();
    //print("here3");
    //print(response1.statusCode);
    //print(response1.toString());
    if (response1.statusCode == 200) {
      //print("here3");
      var fname = file.name.replaceAll(RegExp(r' '), '-');
      var filePath = "${widget.selectedPatient.app_id}/patient_files/$fname";
      var response2 = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/files/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path": filePath,
          "file_name": fname,
          "app_id": widget.selectedPatient.app_id
        }),
      );
      //print("here5");
      //print(response2.statusCode);
      if (response2.statusCode == 201) {
        setState(() {
          selectedFileController.clear();
          futueFiles = fetchFiles();
        });
        // end loading circle
        Navigator.of(context).pop();
        String message =
            "The file ${file.name.replaceAll(RegExp(r' '), '-')} has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    } else {
      internetConnectionPopUp();
    }
  }

  Future<List<PFile>> fetchFiles() async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/files/patients/${widget.selectedPatient.app_id}"));

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PFile> files =
          List<PFile>.from(l.map((model) => PFile.fromJson(model)));
      return files;
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load patients');
    }
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
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

  void medCertPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create Medical Certificate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Medcertinput(
                    startDateController: startDateController,
                    endDateTextController: endDateTextController,
                    retDateTextController: retDateTextController,
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: MIHButton(
                      buttonText: "Generate",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      onTap: () async {
                        if (isMedCertFieldsFilled()) {
                          await generateMedCert();
                          //Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MIHErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        }
                      },
                    ),
                  )
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
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void prescritionPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 900.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Create Perscription",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  PrescripInput(
                    medicineController: medicineController,
                    quantityController: quantityController,
                    dosageController: dosageController,
                    timesDailyController: timesDailyController,
                    noDaysController: noDaysController,
                    noRepeatsController: noRepeatsController,
                    outputController: outputController,
                    selectedPatient: widget.selectedPatient,
                    signedInUser: widget.signedInUser,
                    business: widget.business,
                    businessUser: widget.businessUser,
                  ),
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
                  medicineController.clear();
                  quantityController.clear();
                  dosageController.clear();
                  timesDailyController.clear();
                  noDaysController.clear();
                  noRepeatsController.clear();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploudFilePopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Upload File",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: 700,
                    child: MIHFileField(
                      controller: selectedFileController,
                      hintText: "Select File",
                      editable: false,
                      required: true,
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'png', 'pdf'],
                        );
                        if (result == null) return;
                        final selectedFile = result.files.first;
                        setState(() {
                          selected = selectedFile;
                        });

                        setState(() {
                          selectedFileController.text = selectedFile.name;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: MIHButton(
                      buttonText: "Add File",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      onTap: () {
                        if (isFileFieldsFilled()) {
                          uploadSelectedFile(selected);
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MIHErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        }
                      },
                    ),
                  )
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
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  bool isMedCertFieldsFilled() {
    if (startDateController.text.isEmpty ||
        endDateTextController.text.isEmpty ||
        retDateTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isFileFieldsFilled() {
    if (selectedFileController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  List<Widget> setIcons() {
    if (widget.type == "personal") {
      return [
        Text(
          "Documents",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        IconButton(
          onPressed: () {
            uploudFilePopUp();
          },
          icon: Icon(
            Icons.add,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        )
      ];
    } else {
      return [
        Text(
          "Documents",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        IconButton(
          onPressed: () {
            medCertPopUp();
          },
          icon: Icon(
            Icons.sick_outlined,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        IconButton(
          onPressed: () {
            prescritionPopUp();
          },
          icon: Icon(
            Icons.medication_outlined,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        IconButton(
          onPressed: () {
            uploudFilePopUp();
          },
          icon: Icon(
            Icons.add,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        )
      ];
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateTextController.dispose();
    retDateTextController.dispose();
    selectedFileController.dispose();
    medicineController.dispose();
    quantityController.dispose();
    dosageController.dispose();
    timesDailyController.dispose();
    noDaysController.dispose();
    noRepeatsController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    futueFiles = fetchFiles();
    //patientDetails = getPatientDetails() as Patient;
    //getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    //double width = size.width;
    double height = size.height;
    return FutureBuilder(
      future: futueFiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: height - 100,
            decoration: BoxDecoration(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 3.0),
            ),
            child: const Center(
              child: Mihloadingcircle(),
            ),
          );
        } else if (snapshot.hasData) {
          final filesList = snapshot.data!;
          return Container(
            //height: 300.0,
            decoration: BoxDecoration(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: setIcons(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor()),
                ),
                const SizedBox(height: 10),
                BuildFilesList(
                  files: filesList,
                  signedInUser: widget.signedInUser,
                  selectedPatient: widget.selectedPatient,
                  business: widget.business,
                  businessUser: widget.businessUser,
                ),
              ]),
            ),
          );
        } else {
          return Container(
            height: height - 175,
            decoration: BoxDecoration(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 3.0),
            ),
            child: const Center(
              child: Text("Error Loading Notes"),
            ),
          );
        }
      },
    );
  }
}
