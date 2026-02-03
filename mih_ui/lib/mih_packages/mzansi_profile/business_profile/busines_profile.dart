import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_reviews.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_user_search.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_my_business_team.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_my_business_user.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_employee_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:provider/provider.dart';

class BusinesProfile extends StatefulWidget {
  const BusinesProfile({super.key});

  @override
  State<BusinesProfile> createState() => _BusinesProfileState();
}

class _BusinesProfileState extends State<BusinesProfile> {
  bool _isLoadingInitialData = true;
  late final MihBusinessDetails _businessDetails;
  late final MihMyBusinessUser _businessUser;
  late final MihMyBusinessTeam _businessTeam;
  late final MihBusinessUserSearch _businessUserSearch;
  late final MihBusinessReviews _businessReviews;
  late final MihBusinessQrCode _businessQrCode;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    if (mzansiProfileProvider.user == null) {
      await MihDataHelperServices().loadUserDataWithBusinessesData(
        mzansiProfileProvider,
      );
    }
    await MihBusinessEmployeeServices()
        .fetchEmployees(mzansiProfileProvider, context);
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _businessDetails = MihBusinessDetails();
    _businessUser = MihMyBusinessUser();
    _businessTeam = MihMyBusinessTeam();
    _businessUserSearch = MihBusinessUserSearch();
    _businessReviews = MihBusinessReviews(business: null);
    _businessQrCode = MihBusinessQrCode(business: null);
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
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
          appToolTitles: getToolTitle(),
          appBody: getToolBody(),
          selectedbodyIndex: mzansiProfileProvider.businessIndex,
          onIndexChange: (newIndex) {
            mzansiProfileProvider.setBusinessIndex(newIndex);
          },
        );
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        MzansiProfileProvider mzansiProfileProvider =
            context.read<MzansiProfileProvider>();
        context.goNamed(
          'mihHome',
        );
        mzansiProfileProvider.setHideBusinessUserDetails(true);
        mzansiProfileProvider.setBusinessIndex(0);
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.business)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(0);
    };
    temp[const Icon(Icons.person)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(1);
    };
    temp[const Icon(Icons.people)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(2);
    };
    temp[const Icon(Icons.add)] = () {
      context
          .read<MzansiProfileProvider>()
          .setUserearchResults(userSearchResults: []);
      context.read<MzansiProfileProvider>().setBusinessIndex(3);
    };
    temp[const Icon(Icons.star_rate_rounded)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(4);
    };
    temp[const Icon(Icons.qr_code_rounded)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(5);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiProfileProvider>().businessIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "User",
      "Team",
      "Add",
      "Reviews",
      "Share",
    ];
    return toolTitles;
  }

  List<Widget> getToolBody() {
    return [
      _businessDetails,
      _businessUser,
      _businessTeam,
      _businessUserSearch,
      _businessReviews,
      _businessQrCode,
    ];
  }
}
