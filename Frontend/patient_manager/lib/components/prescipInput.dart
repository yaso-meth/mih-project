import 'package:flutter/material.dart';
import 'package:patient_manager/components/medicineSearch.dart';
import 'package:patient_manager/components/myDropdownInput.dart';
import 'package:patient_manager/components/myMLTextInput.dart';
import 'package:patient_manager/components/mySearchInput.dart';
import 'package:patient_manager/components/mybutton.dart';

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
  String searchString = "";

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

  @override
  void initState() {
    //futueMeds = getMedList(endpointMeds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                width: 300,
                child: MySearchField(
                  controller: widget.medicineController,
                  hintText: "Medicine",
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
                  },
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
                child: MyDropdownField(
                  controller: widget.quantityController,
                  hintText: "Quantity",
                  dropdownOptions: numberOptions,
                  required: true,
                ),
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: 300,
                child: MyDropdownField(
                  controller: widget.dosageController,
                  hintText: "Dosage",
                  dropdownOptions: numberOptions,
                  required: true,
                ),
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: 300,
                child: MyDropdownField(
                  controller: widget.timesDailyController,
                  hintText: "Times Daily",
                  dropdownOptions: numberOptions,
                  required: true,
                ),
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: 300,
                child: MyDropdownField(
                  controller: widget.noDaysController,
                  hintText: "No. Days",
                  dropdownOptions: numberOptions,
                  required: true,
                ),
              ),
              const SizedBox(height: 25.0),
              SizedBox(
                width: 300,
                child: MyDropdownField(
                  controller: widget.noRepeatsController,
                  hintText: "No. Repeats",
                  dropdownOptions: numberOptions,
                  required: true,
                ),
              ),
              SizedBox(
                width: 300,
                child: MyButton(
                  onTap: () {},
                  buttonText: "Add",
                  buttonColor: Colors.blueAccent,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
          //const SizedBox(height: 50.0),
          Column(
            children: [
              SizedBox(
                width: 550,
                height: 400,
                child: MyMLTextField(
                  controller: widget.outputController,
                  hintText: "Prescrion Output",
                  editable: false,
                  required: false,
                ),
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: MyButton(
                  onTap: () {
                    // if (isMedCertFieldsFilled()) {
                    //   generateMedCert();
                    //   Navigator.pop(context);
                    // } else {
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return const MyErrorMessage(
                    //           errorType: "Input Error");
                    //     },
                    //   );
                    // }
                  },
                  buttonText: "Generate",
                  buttonColor: Colors.green,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
