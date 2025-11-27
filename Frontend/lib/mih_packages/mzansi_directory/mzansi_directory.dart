import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_favourite_businesses.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_search_mzansi.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
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

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    await MihDataHelperServices().loadUserDataOnly(
      mzansiProfileProvider,
    );
    await getFavouriteBusinesses();
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

  Future<void> getFavouriteBusinesses() async {
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    await MihMzansiDirectoryServices().getAllUserBookmarkedBusiness(
      profileProvider.user!.app_id,
      directoryProvider,
    );
    List<Business> favBus = [];
    Map<String, ImageProvider<Object>?> favBusImages = {};
    String businessLogoUrl = "";
    for (var bus in directoryProvider.bookmarkedBusinesses) {
      await MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(bus.business_id)
          .then((business) async {
        favBus.add(business!);
        businessLogoUrl = await MihFileApi.getMinioFileUrl(business.logo_path);
        favBusImages[business.business_id] =
            businessLogoUrl != "" ? NetworkImage(businessLogoUrl) : null;
      });
    }
    directoryProvider.setFavouriteBusinesses(
      businesses: favBus,
      businessesImages: favBusImages,
    );
  }

  @override
  void initState() {
    super.initState();
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
    List<Widget> toolBodies = [];
    toolBodies.addAll([
      MihSearchMzansi(),
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
