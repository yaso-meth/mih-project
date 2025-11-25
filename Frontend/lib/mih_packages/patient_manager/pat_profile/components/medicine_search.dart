import 'dart:convert';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_objects/medicine.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/list_builders/build_med_list.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';

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
      MihAlertServices().internetConnectionAlert(context);
      throw Exception('failed to load medicine');
    }
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
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Select Medicine",
      onWindowTapClose: () {
        Navigator.pop(context);
      },
      windowBody: Column(
        children: [
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
      ),
    );
  }
}
