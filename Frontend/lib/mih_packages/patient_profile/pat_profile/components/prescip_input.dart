import 'dart:convert';

import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_numeric_stepper.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/components/medicine_search.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_objects/perscription.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PrescripInput extends StatefulWidget {
  final TextEditingController medicineController;
  final TextEditingController quantityController;
  final TextEditingController dosageController;
  final TextEditingController timesDailyController;
  final TextEditingController noDaysController;
  final TextEditingController noRepeatsController;
  final TextEditingController outputController;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String env;
  const PrescripInput({
    super.key,
    required this.medicineController,
    required this.quantityController,
    required this.dosageController,
    required this.timesDailyController,
    required this.noDaysController,
    required this.noRepeatsController,
    required this.outputController,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.env,
  });

  @override
  State<PrescripInput> createState() => _PrescripInputState();
}

class _PrescripInputState extends State<PrescripInput> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  List<Perscription> perscriptionObjOutput = [];
  late double width;
  late double height;

  final numberOptions = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30"
  ];

  Future<void> generatePerscription() async {
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    DateTime now = new DateTime.now();
    // DateTime date = new DateTime(now.year, now.month, now.day);
    String fileName =
        "Perscription-${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}-${now.toString().substring(0, 19)}.pdf"
            .replaceAll(RegExp(r' '), '-');

    var response1 = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/generate/perscription/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": widget.selectedPatient.app_id,
        "env": widget.env,
        "patient_full_name":
            "${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}",
        "fileName": fileName,
        "id_no": widget.selectedPatient.id_no,
        "docfname":
            "DR. ${widget.signedInUser.fname} ${widget.signedInUser.lname}",
        "busName": widget.business!.Name,
        "busAddr": "*TO BE ADDED IN THE FUTURE*",
        "busNo": widget.business!.contact_no,
        "busEmail": widget.business!.bus_email,
        "logo_path": widget.business!.logo_path,
        "sig_path": widget.businessUser!.sig_path,
        "data": perscriptionObjOutput,
      }),
    );
    //print(response1.statusCode);
    if (response1.statusCode == 200) {
      var response2 = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/patient_files/insert/"),
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
          //To do
          widget.medicineController.clear();
          widget.dosageController.clear();
          widget.timesDailyController.clear();
          widget.noDaysController.clear();
          widget.timesDailyController.clear();
          widget.noRepeatsController.clear();
          widget.quantityController.clear();
          widget.outputController.clear();
          // futueFiles = fetchFiles();
        });
        // end loading circle
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/patient-manager/patient',
            arguments: PatientViewArguments(
              widget.signedInUser,
              widget.selectedPatient,
              widget.businessUser,
              widget.business,
              "business",
            ));
        String message =
            "The perscription $fileName has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    } else {
      internetConnectionPopUp();
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
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

  void getMedsPopUp(TextEditingController medSearch) {
    showDialog(
      context: context,
      builder: (context) {
        return MedicineSearch(
          searchVlaue: medSearch,
        );
      },
    );
  }

  bool isFieldsFilled() {
    if (widget.medicineController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void updatePerscriptionList() {
    String name;
    String unit;
    String form;
    List<String> medNameList = widget.medicineController.text.split("%t");
    if (medNameList.length == 1) {
      name = medNameList[0];
      unit = "";
      form = "";
    } else {
      name = medNameList[0];
      unit = medNameList[1];
      form = medNameList[2];
    }
    int quantityCalc = calcQuantity(
        widget.dosageController.text,
        widget.timesDailyController.text,
        widget.noDaysController.text,
        medNameList[2].toLowerCase());
    Perscription tempObj = Perscription(
      name: name,
      unit: unit,
      form: form,
      fullForm: getFullDoagesForm(form),
      quantity: "$quantityCalc",
      dosage: widget.dosageController.text,
      times: widget.timesDailyController.text,
      days: widget.noDaysController.text,
      repeats: widget.noRepeatsController.text,
    );
    perscriptionObjOutput.add(tempObj);
  }

  String getPerscTitle(int index) {
    return "${perscriptionObjOutput[index].name} - ${perscriptionObjOutput[index].form}";
  }

  String getPerscSubtitle(int index) {
    if (perscriptionObjOutput[index].form.toLowerCase() == "syr") {
      String unit = perscriptionObjOutput[index].unit.toLowerCase();
      if (perscriptionObjOutput[index].unit.toLowerCase().contains("ml")) {
        unit = "ml";
      }
      return "${perscriptionObjOutput[index].dosage} $unit, ${perscriptionObjOutput[index].times} time(s) daily, for ${perscriptionObjOutput[index].days} day(s)\nQuantity: ${perscriptionObjOutput[index].quantity}\nNo. of repeats: ${perscriptionObjOutput[index].repeats}";
    } else {
      return "${perscriptionObjOutput[index].dosage} ${perscriptionObjOutput[index].fullForm}(s), ${perscriptionObjOutput[index].times} time(s) daily, for ${perscriptionObjOutput[index].days} day(s)\nQuantity: ${perscriptionObjOutput[index].quantity}\nNo. of repeats: ${perscriptionObjOutput[index].repeats}";
    }
  }

  String getFullDoagesForm(String abr) {
    var dosageFormList = {
      "liq": "liquid",
      "tab": "tablet",
      "cap": "capsule",
      "cps": "capsule",
      "oin": "ointment",
      "lit": "lotion",
      "lot": "lotion",
      "inj": "injection",
      "syr": "syrup",
      "dsp": "effervescent tablet",
      "eft": "effervescent tablet",
      "ear": "drops",
      "drp": "drops",
      "opd": "drops",
      "udv": "vial",
      "sus": "suspension",
      "susp": "suspension",
      "cal": "calasthetic",
      "sol": "solution",
      "sln": "solution",
      "neb": "nebuliser",
      "inh": "inhaler",
      "spo": "inhaler",
      "inf": "infusion",
      "chg": "chewing Gum",
      "vac": "vacutainer",
      "vag": "vaginal gel",
      "jel": "gel",
      "eyo": "eye ointment",
      "vat": "vaginal cream",
      "poi": "injection",
      "ped": "powder",
      "pow": "powder",
      "por": "powder",
      "sac": "sachet",
      "sup": "suppository",
      "cre": "cream",
      "ptd": "patch",
      "ect": "tablet",
      "nas": "spray",
    };
    String form;
    if (dosageFormList[abr.toLowerCase()] == null) {
      form = abr;
    } else {
      form = dosageFormList[abr.toLowerCase()]!;
    }
    return form;
  }

  int calcQuantity(String dosage, String times, String days, String form) {
    var dosageFormList = [
      "tab",
      "cap",
      "cps",
      "dsp",
      "eft",
      "udv",
      "chg",
      "sac",
      "sup",
      "ptd",
      "ect",
    ];
    if (dosageFormList.contains(form)) {
      return int.parse(dosage) * int.parse(times) * int.parse(days);
    } else {
      return 1;
    }
  }

  Widget displayMedInput() {
    return Column(
      children: [
        MihForm(
          formKey: _formKey,
          formFields: [
            MihSearchBar(
              controller: widget.medicineController,
              hintText: "Search Medicine",
              prefixIcon: Icons.search,
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              hintColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              onPrefixIconTap: () {
                getMedsPopUp(widget.medicineController);
              },
              onClearIconTap: () {
                widget.medicineController.clear();
              },
              searchFocusNode: _searchFocusNode,
            ),
            const SizedBox(height: 10.0),
            MihNumericStepper(
              controller: widget.dosageController,
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              hintText: "Dosage",
              requiredText: true,
              minValue: 1,
              // maxValue: 5,
              validationOn: true,
            ),
            const SizedBox(height: 10.0),
            MihNumericStepper(
              controller: widget.timesDailyController,
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              hintText: "Times Daily",
              requiredText: true,
              minValue: 1,
              // maxValue: 5,
              validationOn: true,
            ),
            const SizedBox(height: 10.0),
            MihNumericStepper(
              controller: widget.noDaysController,
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              hintText: "No. Days",
              requiredText: true,
              minValue: 1,
              // maxValue: 5,
              validationOn: true,
            ),
            const SizedBox(height: 10.0),
            MihNumericStepper(
              controller: widget.noRepeatsController,
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              hintText: "No.Repeats",
              requiredText: true,
              minValue: 0,
              // maxValue: 5,
              validationOn: true,
            ),
            const SizedBox(height: 15.0),
            Center(
              child: MihButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isFieldsFilled()) {
                      setState(() {
                        updatePerscriptionList();
                        widget.medicineController.clear();
                        widget.quantityController.text = "1";
                        widget.dosageController.text = "1";
                        widget.timesDailyController.text = "1";
                        widget.noDaysController.text = "1";
                        widget.noRepeatsController.text = "0";
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const MIHErrorMessage(
                              errorType: "Input Error");
                        },
                      );
                    }
                  } else {
                    MihAlertServices().formNotFilledCompletely(context);
                  }
                },
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 300,
                child: Text(
                  "Add",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget displayPerscList() {
    return Column(
      children: [
        Container(
          width: 550,
          height: 325,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 3.0),
          ),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(),
              );
            },
            itemCount: perscriptionObjOutput.length,
            itemBuilder: (context, index) {
              //final patient = widget.patients[index].id_no.contains(widget.searchString);
              return ListTile(
                title: Text(
                  getPerscTitle(index),
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
                subtitle: Text(
                  getPerscSubtitle(index),
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
                //onTap: () {},
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  onPressed: () {
                    setState(() {
                      perscriptionObjOutput.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15.0),
        MihButton(
          onPressed: () async {
            if (perscriptionObjOutput.isNotEmpty) {
              //print(jsonEncode(perscriptionObjOutput));
              await generatePerscription();
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return const MIHErrorMessage(errorType: "Input Error");
                },
              );
            }
          },
          buttonColor: MzanziInnovationHub.of(context)!.theme.successColor(),
          width: 300,
          child: Text(
            "Generate",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //futueMeds = getMedList(endpointMeds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      // mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 500, child: displayMedInput()),
        displayPerscList(),
      ],
    );
  }
}
