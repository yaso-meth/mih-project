import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_reviews.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';

class MzansiBusinessProfileView extends StatefulWidget {
  final BusinessViewArguments? arguments;
  final String? businessId;
  const MzansiBusinessProfileView({
    super.key,
    required this.arguments,
    required this.businessId,
  });

  @override
  State<MzansiBusinessProfileView> createState() =>
      _MzansiBusinessProfileViewState();
}

class _MzansiBusinessProfileViewState extends State<MzansiBusinessProfileView> {
  int _selcetedIndex = 0;
  Business? business;
  String startUpSearch = "";

  Future<void> _fetchBusinessDetails() async {
    if (widget.arguments != null) {
      setState(() {
        business = widget.arguments!.business;
        startUpSearch = widget.arguments!.startUpSearch ?? "";
      });
    } else if (widget.businessId != null) {
      final biz = await MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(widget.businessId!);
      if (biz == null) {
        context.goNamed(
          'mihHome',
          extra: true,
        );
      } else {
        KenLogger.success("Business found: ${biz.Name}");
        setState(() {
          business = biz;
          startUpSearch = "";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (business == null) {
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
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          "mzansiDirectory",
          extra: MzansiDirectoryArguments(
            personalSearch: false,
            startSearchText: business!.Name,
          ),
        );
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

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihBusinessDetailsView(
        business: business!,
        startUpSearch: startUpSearch,
      ),
      MihBusinessReviews(business: business!),
      MihBusinessQrCode(
        business: business!,
        startUpSearch: startUpSearch,
      )
    ];
    return toolBodies;
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
