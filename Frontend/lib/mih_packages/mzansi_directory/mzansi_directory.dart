import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_favourite_businesses.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_search_mzansi.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:provider/provider.dart';

class MzansiDirectory extends StatefulWidget {
  const MzansiDirectory({
    super.key,
  });

  @override
  State<MzansiDirectory> createState() => _MzansiDirectoryState();
}

class _MzansiDirectoryState extends State<MzansiDirectory> {
  late Future<Position?> futurePosition =
      MIHLocationAPI().getGPSPosition(context);

  Future<void> initialiseGPSLocation() async {
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    MIHLocationAPI().getGPSPosition(context).then((position) {
      directoryProvider.setUserPosition(position);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialiseGPSLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MzansiDirectoryProvider>().toolIndex,
      onIndexChange: (newValue) {
        context.read<MzansiDirectoryProvider>().setToolIndex(newValue);
      },
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [];
    // String myLocation = "Getting Your GPS Location Ready";
    // if (directoryProvider.userPosition != null) {
    //   myLocation = directoryProvider.userPosition
    //       .toString()
    //       .replaceAll("Latitude: ", "")
    //       .replaceAll("Longitude: ", "");
    // }
    toolBodies.addAll([
      MihSearchMzansi(
          // personalSearch: directoryProvider.personalSearch,
          // startSearchText: "",
          ),
      // MihContacts(),
      MihFavouriteBusinesses(),
    ]);
    return toolBodies;
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        MzansiDirectoryProvider directoryProvider =
            context.read<MzansiDirectoryProvider>();
        context.goNamed(
          'mihHome',
        );
        directoryProvider.setToolIndex(0);
        directoryProvider.setPersonalSearch(true);
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.search)] = () {
      context.read<MzansiDirectoryProvider>().setToolIndex(0);
    };
    temp[const Icon(Icons.business_center)] = () {
      context.read<MzansiDirectoryProvider>().setToolIndex(1);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiDirectoryProvider>().toolIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Mzansi Search",
      "Favourite Businesses",
      // "Contacts",
    ];
    return toolTitles;
  }
}
