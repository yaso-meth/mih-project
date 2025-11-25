import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/builder/build_business_access_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_access_controls_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
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
  bool isLoading = true;
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

  void refreshList() {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    MihAccessControllsProvider accessProvider =
        context.read<MihAccessControllsProvider>();
    if (forceRefresh == true) {
      MihAccessControlsServices().getBusinessAccessListOfPatient(
        mzansiProfileProvider.user!.app_id,
        accessProvider,
      );
      setState(() {
        forceRefresh = false;
      });
    } else if (selectedDropdown != filterController.text) {
      MihAccessControlsServices().getBusinessAccessListOfPatient(
        mzansiProfileProvider.user!.app_id,
        accessProvider,
      );
      setState(() {
        selectedDropdown = filterController.text;
      });
    }
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
        return MihSingleChildScroll(
          child: Column(
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
                      enableSearch: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                  ),
                  IconButton(
                    iconSize: 35,
                    onPressed: () {
                      setState(() {
                        forceRefresh = true;
                      });
                      KenLogger.warning("Refreshing Access List");
                      refreshList();
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              BuildBusinessAccessList(
                filterText: filterController.text,
                onSuccessUpate: () {
                  setState(() {
                    forceRefresh = true;
                  });
                  refreshList();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> initiasizeAccessList() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    MihAccessControllsProvider accessProvider =
        context.read<MihAccessControllsProvider>();
    setState(() {
      isLoading = true;
    });
    await MihAccessControlsServices().getBusinessAccessListOfPatient(
      mzansiProfileProvider.user!.app_id,
      accessProvider,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedDropdown = "All";
    filterController.text = "All";
    filterController.addListener(refreshList);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initiasizeAccessList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(),
    );
  }
}
