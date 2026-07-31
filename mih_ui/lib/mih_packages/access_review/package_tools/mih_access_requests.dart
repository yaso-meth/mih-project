import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/builder/build_business_access_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MihAccessRequest extends StatefulWidget {
  const MihAccessRequest({
    super.key,
  });

  @override
  State<MihAccessRequest> createState() => _MihAccessRequestState();
}

class _MihAccessRequestState extends State<MihAccessRequest> {
  TextEditingController filterController = TextEditingController();
  bool isLoading = false;
  String baseUrl = AppEnviroment.baseApiUrl;

  String errorCode = "";
  String errorBody = "";
  String datefilter = "";
  String accessFilter = "";
  bool forceRefresh = false;
  late String selectedDropdown;

  List<PatientAccess> filterSearchResults(List<PatientAccess> accessList) {
    List<PatientAccess> templist = [];
    for (var item in accessList) {
      if (filterController.text == "All") {
        templist.add(item);
      } else {
        if (item.status.contains(filterController.text.toLowerCase())) {
          templist.add(item);
        }
      }
    }
    return templist;
  }

  void refreshList() async {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    MihAccessControllsProvider accessProvider =
        context.read<MihAccessControllsProvider>();
    setState(() {
      forceRefresh = true;
    });
    await accessProvider.syncWithMihServerData(profileProvider);
    setState(() {
      forceRefresh = false;
    });
  }

  Widget getBody() {
    return Consumer2<MzansiProfileProvider, MihAccessControllsProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider,
          MihAccessControllsProvider accessProvider,
          Widget? child) {
        if (isLoading) {
          return const Center(
            child: Mihloadingcircle(),
          );
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: MihDropdownField(
                    controller: filterController,
                    hintText: "Access Type",
                    dropdownOptions: const [
                      "All",
                      "Approved",
                      "Pending",
                      "Declined",
                      "Cancelled",
                    ],
                    requiredText: true,
                    editable: true,
                    enableSearch: false,
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                  ),
                ),
                IconButton(
                  iconSize: 35,
                  onPressed: () {
                    refreshList();
                  },
                  icon: const Icon(
                    Icons.refresh,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BuildBusinessAccessList(
                filterText: filterController.text,
                onSuccessUpate: () {
                  refreshList();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedDropdown = "All";
    filterController.text = "All";
    filterController.addListener(refreshList);
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(),
    );
  }
}
