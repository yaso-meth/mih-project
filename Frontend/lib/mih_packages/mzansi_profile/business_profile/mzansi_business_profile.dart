import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_reviews.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_user_search.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_my_business_team.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_my_business_user.dart';

class MzansiBusinessProfile extends StatefulWidget {
  final BusinessArguments arguments;
  const MzansiBusinessProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<MzansiBusinessProfile> createState() => _MzansiBusinessProfileState();
}

class _MzansiBusinessProfileState extends State<MzansiBusinessProfile> {
  int _selcetedIndex = 0;
  late Future<String> futureLogoUrl;
  late Future<String> futureProPicUrl;
  late Future<String> futureUserSignatureUrl;

  @override
  void initState() {
    super.initState();
    futureLogoUrl = MihFileApi.getMinioFileUrl(
      widget.arguments.business!.logo_path,
      context,
    );
    futureProPicUrl = MihFileApi.getMinioFileUrl(
      widget.arguments.signedInUser.pro_pic_path,
      context,
    );
    futureUserSignatureUrl = MihFileApi.getMinioFileUrl(
      widget.arguments.businessUser!.sig_path,
      context,
    );
  }

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
        context.goNamed(
          'mihHome',
          extra: false,
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
    temp[const Icon(Icons.person)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    // temp[const Icon(Icons.warning)] = () {
    //   setState(() {
    //     _selcetedIndex = 2;
    //   });
    // };
    temp[const Icon(Icons.people)] = () {
      setState(() {
        _selcetedIndex = 2;
      });
    };
    temp[const Icon(Icons.add)] = () {
      setState(() {
        _selcetedIndex = 3;
      });
    };
    temp[const Icon(Icons.star_rate_rounded)] = () {
      setState(() {
        _selcetedIndex = 4;
      });
    };
    temp[const Icon(Icons.qr_code_rounded)] = () {
      setState(() {
        _selcetedIndex = 5;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      FutureBuilder(
          future: futureLogoUrl,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Mihloadingcircle());
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final logoUrl = snapshot.data!.isNotEmpty
                  ? NetworkImage(snapshot.data!)
                  : null;
              return MihBusinessDetails(
                arguments: widget.arguments,
                logoImage: logoUrl,
              );
            } else {
              return Text("Error: ${snapshot.error}");
            }
          }),
      FutureBuilder<List<String>>(
        future: Future.wait([futureProPicUrl, futureUserSignatureUrl]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Mihloadingcircle());
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final proPicUrl = NetworkImage(snapshot.data![0]);
            print("=============== Signature URL: ${snapshot.data![1]}");
            final signatureUrl = snapshot.data![1].isNotEmpty
                ? NetworkImage(snapshot.data![1])
                : null;
            return MihMyBusinessUser(
              arguments: widget.arguments,
              userProPicImage: proPicUrl,
              userSignatureImage: signatureUrl,
            );
          } else {
            return Text("Error: ${snapshot.error}");
          }
        },
      ),
      // MihBusinessProfile(arguments: widget.arguments),
      MihMyBusinessTeam(arguments: widget.arguments),
      MihBusinessUserSearch(arguments: widget.arguments),
      MihBusinessReviews(business: widget.arguments.business!),
      MihBusinessQrCode(
        business: widget.arguments.business!,
        startUpSearch: "",
      ),
    ];
    return toolBodies;
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
}
