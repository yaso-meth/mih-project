import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_favourite_businesses.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_search_mzansi.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';

class MzansiDirectory extends StatefulWidget {
  final MzansiDirectoryArguments arguments;
  const MzansiDirectory({
    super.key,
    required this.arguments,
  });

  @override
  State<MzansiDirectory> createState() => _MzansiDirectoryState();
}

class _MzansiDirectoryState extends State<MzansiDirectory> {
  int _selcetedIndex = 0;
  late Future<Position?> futurePosition =
      MIHLocationAPI().getGPSPosition(context);

  @override
  void initState() {
    super.initState();
    if (widget.arguments.packageIndex == null) {
      _selcetedIndex = 0;
    } else {
      _selcetedIndex = widget.arguments.packageIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('MzansiDirectory build method called!');
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
      },
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      FutureBuilder(
          future: futurePosition,
          builder: (context, asyncSnapshot) {
            String myLocation = "";
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              myLocation = "Getting Your GPS Location Ready";
            } else {
              myLocation = asyncSnapshot.data
                  .toString()
                  .replaceAll("Latitude: ", "")
                  .replaceAll("Longitude: ", "");
            }
            return MihSearchMzansi(
              personalSearch: widget.arguments.personalSearch,
              myLocation: myLocation,
              startSearchText: widget.arguments.startSearchText,
            );
          }),
      // MihContacts(),
      FutureBuilder(
          future: futurePosition,
          builder: (context, asyncSnapshot) {
            String myLocation = "";
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              myLocation = "Getting Your GPS Location Ready";
            } else {
              myLocation = asyncSnapshot.data
                  .toString()
                  .replaceAll("Latitude: ", "")
                  .replaceAll("Longitude: ", "");
            }
            return MihFavouriteBusinesses(
              myLocation: myLocation,
            );
          }),
    ];
    return toolBodies;
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.search)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    // temp[const Icon(Icons.person)] = () {
    //   setState(() {
    //     _selcetedIndex = 1;
    //   });
    // };
    temp[const Icon(Icons.business_center)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Mzansi Search",
      "Favourite Businesses",
      "Contacts",
    ];
    return toolTitles;
  }
}
