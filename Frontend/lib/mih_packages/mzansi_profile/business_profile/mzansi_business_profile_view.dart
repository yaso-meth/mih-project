import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details_view.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_reviews.dart';

class MzansiBusinessProfileView extends StatefulWidget {
  final Business business;
  const MzansiBusinessProfileView({
    super.key,
    required this.business,
  });

  @override
  State<MzansiBusinessProfileView> createState() =>
      _MzansiBusinessProfileViewState();
}

class _MzansiBusinessProfileViewState extends State<MzansiBusinessProfileView> {
  int _selcetedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihBusinessDetailsView(business: widget.business),
      MihBusinessReviews(businessId: widget.business.business_id),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "Reviews",
    ];
    return toolTitles;
  }
}
