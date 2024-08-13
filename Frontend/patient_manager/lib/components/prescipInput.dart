import 'package:flutter/material.dart';
import 'package:patient_manager/components/medicineSearch.dart';
import 'package:patient_manager/components/mihDropdownInput.dart';
import 'package:patient_manager/components/mihErrorMessage.dart';
import 'package:patient_manager/components/mihSearchInput.dart';
import 'package:patient_manager/components/mihButton.dart';
import 'package:patient_manager/main.dart';

class PrescripInput extends StatefulWidget {
  final TextEditingController medicineController;
  final TextEditingController quantityController;
  final TextEditingController dosageController;
  final TextEditingController timesDailyController;
  final TextEditingController noDaysController;
  final TextEditingController noRepeatsController;
  final TextEditingController outputController;

  const PrescripInput({
    super.key,
    required this.medicineController,
    required this.quantityController,
    required this.dosageController,
    required this.timesDailyController,
    required this.noDaysController,
    required this.noRepeatsController,
    required this.outputController,
  });

  @override
  State<PrescripInput> createState() => _PrescripInputState();
}

class _PrescripInputState extends State<PrescripInput> {
  //String perscriptionOutput = "";
  List<List<String>> perscriptionOutput = [];
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
    if (widget.medicineController.text.isEmpty ||
        widget.quantityController.text.isEmpty ||
        widget.dosageController.text.isEmpty ||
        widget.timesDailyController.text.isEmpty ||
        widget.noDaysController.text.isEmpty ||
        widget.noRepeatsController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void updatePerscriptionList() {
    List<String> medNameList = widget.medicineController.text.split("%t");
    List<String> temp = [];
    temp.add(medNameList[0]); //Name 0
    temp.add(medNameList[1]); //Unit 1
    temp.add(medNameList[2]); //Form 2
    temp.add(widget.quantityController.text); //Quantity 3
    temp.add(widget.quantityController.text); //Dosage 4
    temp.add(widget.timesDailyController.text); //Times Daily 5
    temp.add(widget.noDaysController.text); //No Days 6
    temp.add(widget.noRepeatsController.text); //No Repeats 7

    perscriptionOutput.add(temp);
  }

  String getPerscTitle(int index) {
    return "${perscriptionOutput[index][0]} (${perscriptionOutput[index][1]})";
  }

  String getPerscSubtitle(int index) {
    if (perscriptionOutput[index][3].toLowerCase() == "syr") {
      return "${perscriptionOutput[index][4]} ${perscriptionOutput[index][3]}, ${perscriptionOutput[index][5]} times daily, for ${perscriptionOutput[index][6]}\nQuantity: ${perscriptionOutput[index][3]}\nNo. of repeats ${perscriptionOutput[index][7]}";
    } else {
      return "${perscriptionOutput[index][4]} ${perscriptionOutput[index][1]}, ${perscriptionOutput[index][5]} times daily, for ${perscriptionOutput[index][6]}\nQuantity: ${perscriptionOutput[index][3]}\nNo. of repeats ${perscriptionOutput[index][7]}";
    }
  }

  Widget displayMedInput() {
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: MIHSearchField(
            controller: widget.medicineController,
            hintText: "Medicine",
            required: true,
            editable: true,
            onTap: () {
              getMedsPopUp(widget.medicineController);
            },
          ),
        ),
        const SizedBox(height: 25.0),
        SizedBox(
          width: 300,
          child: MIHDropdownField(
            controller: widget.quantityController,
            hintText: "Quantity",
            dropdownOptions: numberOptions,
            required: true,
            editable: true,
          ),
        ),
        const SizedBox(height: 25.0),
        SizedBox(
          width: 300,
          child: MIHDropdownField(
            controller: widget.dosageController,
            hintText: "Dosage",
            dropdownOptions: numberOptions,
            required: true,
            editable: true,
          ),
        ),
        const SizedBox(height: 25.0),
        SizedBox(
          width: 300,
          child: MIHDropdownField(
            controller: widget.timesDailyController,
            hintText: "Times Daily",
            dropdownOptions: numberOptions,
            required: true,
            editable: true,
          ),
        ),
        const SizedBox(height: 25.0),
        SizedBox(
          width: 300,
          child: MIHDropdownField(
            controller: widget.noDaysController,
            hintText: "No. Days",
            dropdownOptions: numberOptions,
            required: true,
            editable: true,
          ),
        ),
        const SizedBox(height: 25.0),
        SizedBox(
          width: 300,
          child: MIHDropdownField(
            controller: widget.noRepeatsController,
            hintText: "No. Repeats",
            dropdownOptions: numberOptions,
            required: true,
            editable: true,
          ),
        ),
        SizedBox(
          width: 300,
          child: MIHButton(
            buttonText: "Add",
            buttonColor:
                MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            onTap: () {
              if (isFieldsFilled()) {
                setState(() {
                  updatePerscriptionList();
                  widget.medicineController.clear();
                  widget.quantityController.clear();
                  widget.dosageController.clear();
                  widget.timesDailyController.clear();
                  widget.noDaysController.clear();
                  widget.noRepeatsController.clear();
                });

                //addPatientAPICall();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const MIHErrorMessage(errorType: "Input Error");
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }

  Widget displayPerscList() {
    return Column(
      children: [
        Container(
          width: 550,
          height: 400,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 3.0),
          ),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemCount: perscriptionOutput.length,
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
                      perscriptionOutput.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: 300,
          height: 100,
          child: MIHButton(
            onTap: () {
              // if (isMedCertFieldsFilled()) {
              //   generateMedCert();
              //   Navigator.pop(context);
              // } else {
              //   showDialog(
              //     context: context,
              //     builder: (context) {
              //       return const MIHErrorMessage(
              //           errorType: "Input Error");
              //     },
              //   );
              // }
            },
            buttonText: "Generate",
            buttonColor: MzanziInnovationHub.of(context)!.theme.successColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    //futueMeds = getMedList(endpointMeds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    return Container(
      //width: ,
      height: (height / 3) * 2,
      child: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            displayMedInput(),
            displayPerscList(),
          ],
        ),
      ),
    );
  }
}
