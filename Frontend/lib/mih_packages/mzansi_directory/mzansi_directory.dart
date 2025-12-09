import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_favourite_businesses.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_search_mzansi.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
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
  bool _isLoadingInitialData = true;
  late Future<Position?> futurePosition =
      MIHLocationAPI().getGPSPosition(context);
  late final MihSearchMzansi _searchTool;
  late final MihFavouriteBusinesses _favouritesTool;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    if (mzansiProfileProvider.user == null) {
      await MihDataHelperServices().loadUserDataOnly(
        mzansiProfileProvider,
      );
    }
    setState(() {
      _isLoadingInitialData = false;
    });
    initialiseGPSLocation();
  }

  Future<void> initialiseGPSLocation() async {
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    Position? userPos = await MIHLocationAPI().getGPSPosition(context);
    directoryProvider.setUserPosition(userPos);
  }

  @override
  void initState() {
    super.initState();
    _searchTool = const MihSearchMzansi();
    _favouritesTool = const MihFavouriteBusinesses();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appBody: getToolBody(),
          appToolTitles: getToolTitle(),
          selectedbodyIndex: directoryProvider.toolIndex,
          onIndexChange: (newValue) {
            directoryProvider.setToolIndex(newValue);
          },
        );
      },
    );
  }

  List<Widget> getToolBody() {
    return [
      _searchTool,
      _favouritesTool,
    ];
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
