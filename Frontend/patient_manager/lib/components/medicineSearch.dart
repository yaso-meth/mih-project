import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildMedList.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/objects/medicine.dart';
import 'package:http/http.dart' as http;

class MedicineSearch extends StatefulWidget {
  final TextEditingController searchVlaue;
  const MedicineSearch({
    super.key,
    required this.searchVlaue,
  });

  @override
  State<MedicineSearch> createState() => _MedicineSearchState();
}

class _MedicineSearchState extends State<MedicineSearch> {
  final String endpointMeds = "http://localhost:80/users/medicine/";

  //TextEditingController searchController = TextEditingController();

  late Future<List<Medicine>> futueMeds;
  //String searchString = "";

  Future<List<Medicine>> getMedList(String endpoint) async {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Medicine> medicines =
          List<Medicine>.from(l.map((model) => Medicine.fromJson(model)));
      // List<Medicine> meds = [];
      // medicines.forEach((element) => meds.add(element.name));
      return medicines;
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load medicine');
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

  @override
  void initState() {
    futueMeds = getMedList(endpointMeds + widget.searchVlaue.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: 700.0,
            //height: 475.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.blueAccent, width: 5.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Medicine",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25.0),
                FutureBuilder(
                  future: futueMeds,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 400,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final medsList = snapshot.data!;
                      return SizedBox(
                        height: 400,
                        child: BuildMedicinesList(
                          contoller: widget.searchVlaue,
                          medicines: medsList,
                          //searchString: searchString,
                        ),
                      );
                    } else {
                      return const SizedBox(
                        height: 400,
                        child: const Center(
                          child: Text(
                            "No Match Found\nPlease close and manually capture medicine",
                            style: TextStyle(fontSize: 25, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
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
    );
  }
}
