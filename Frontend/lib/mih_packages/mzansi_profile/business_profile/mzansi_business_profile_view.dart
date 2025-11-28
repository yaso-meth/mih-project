import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_reviews.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:provider/provider.dart';

class MzansiBusinessProfileView extends StatefulWidget {
  final String? businessId;
  const MzansiBusinessProfileView({
    super.key,
    required this.businessId,
  });

  @override
  State<MzansiBusinessProfileView> createState() =>
      _MzansiBusinessProfileViewState();
}

class _MzansiBusinessProfileViewState extends State<MzansiBusinessProfileView> {
  int _selcetedIndex = 0;
  late final MihBusinessDetailsView _businessDetailsView;
  late final MihBusinessReviews _businessReviews;
  late final MihBusinessQrCode _businessQrCode;

  Future<void> _fetchBusinessDetails(
      MzansiDirectoryProvider directoryProvider) async {
    if (widget.businessId != null) {
      final biz = await MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(widget.businessId!);
      if (biz == null) {
        context.goNamed(
          'mihHome',
          extra: true,
        );
      } else {
        KenLogger.success("Business found: ${biz.Name}");
        directoryProvider.setSelectedBusiness(business: biz);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    _businessDetailsView = MihBusinessDetailsView();
    _businessReviews =
        MihBusinessReviews(business: directoryProvider.selectedBusiness!);
    _businessQrCode = MihBusinessQrCode(
      business: directoryProvider.selectedBusiness!,
    );
    _fetchBusinessDetails(directoryProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        if (directoryProvider.selectedBusiness == null) {
          KenLogger.warning("Business is null, showing loading indicator");
          return Scaffold(
            body: const Center(
              child: Mihloadingcircle(),
            ),
          );
        } else {
          return MihPackage(
            appActionButton: getAction(),
            appTools: getTools(),
            appBody: getToolBody(directoryProvider),
            appToolTitles: getToolTitle(),
            selectedbodyIndex: _selcetedIndex,
            onIndexChange: (newValue) {
              setState(() {
                _selcetedIndex = newValue;
              });
            },
          );
        }
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        MzansiProfileProvider profileProvider =
            context.read<MzansiProfileProvider>();
        if (profileProvider.user == null) {
          context.goNamed(
            'mihHome',
          );
        } else {
          context.pop();
        }
        // context.goNamed(
        //   "mzansiDirectory",
        // );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.business)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.star_rate_rounded)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    temp[const Icon(Icons.qr_code_rounded)] = () {
      setState(() {
        _selcetedIndex = 2;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody(MzansiDirectoryProvider directoryProvider) {
    return [
      _businessDetailsView,
      _businessReviews,
      _businessQrCode,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "Reviews",
      "Share Business",
    ];
    return toolTitles;
  }
}
