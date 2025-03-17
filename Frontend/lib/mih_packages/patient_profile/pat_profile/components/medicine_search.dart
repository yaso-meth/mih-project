import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/medicine.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/list_builders/build_med_list.dart';
import 'package:flutter/material.dart';

import 'package:supertokens_flutter/http.dart' as http;

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
  final String endpointMeds = "${AppEnviroment.baseApiUrl}/users/medicine/";

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
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    futueMeds = getMedList(endpointMeds + widget.searchVlaue.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHWindow(
      fullscreen: false,
      windowTitle: "Select Medicine",
      windowTools: [],
      onWindowTapClose: () {
        Navigator.pop(context);
      },
      windowBody: [
        FutureBuilder(
          future: futueMeds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 400,
                child: Mihloadingcircle(),
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
                child: Center(
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
    );
  }
}
