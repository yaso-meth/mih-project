import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_add_business_link_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_manage_business_link_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MihBusinessLinks extends StatefulWidget {
  final bool viewMode;
  const MihBusinessLinks({
    super.key,
    required this.viewMode,
  });

  @override
  State<MihBusinessLinks> createState() => _MihBusinessLinksState();
}

class _MihBusinessLinksState extends State<MihBusinessLinks> {
  late Future<List<ProfileLink>> _futureLinks;
  final List<ProfileLink> _dummyLinks = List.generate(
    6,
    (index) => ProfileLink(
      idprofile_links: index,
      app_id: '',
      business_id: '',
      site_name: '',
      custom_name: '',
      destination: '',
      order: index,
    ),
  );

  void manageProfileLinksWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihManageBusinessLinkWindow(),
    );
  }

  void addProfileLinksWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihAddBusinessLinkWindow(),
    );
  }

  void getLinkData() async {
    if (widget.viewMode) {
      MzansiDirectoryProvider directoryProvider =
          context.read<MzansiDirectoryProvider>();
      _futureLinks = MihProfileLinksServices.getBusinessProfileLinksMD(
          directoryProvider.selectedBusiness!.business_id);
    }
  }

  @override
  void initState() {
    super.initState();
    getLinkData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return Consumer(builder: (BuildContext context,
        MzansiProfileProvider profileProvider, Widget? child) {
      return MihSingleChildScroll(
        scrollbarOn: true,
        child: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.2)
                  : EdgeInsets.symmetric(horizontal: width * 0),
          child: Column(
            children: [
              FittedBox(
                child: Text(
                  "Profile Links",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: MihColors.secondary(),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              if (widget.viewMode)
                FutureBuilder<List<ProfileLink>>(
                  future: _futureLinks,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState != ConnectionState.done) {
                      return Skeletonizer(
                        enabled: true,
                        enableSwitchAnimation: true,
                        effect: ShimmerEffect(
                          baseColor: MihColors.highlight(),
                          highlightColor: MihColors.secondary(),
                        ),
                        child: MihProfileLinks(
                          displayCustomName: true,
                          links: _dummyLinks,
                        ),
                      );
                    }

                    if (asyncSnapshot.hasError) {
                      return Column(
                        children: [
                          Icon(
                            Icons.link_off,
                            size: 150,
                            color: MihColors.secondary(),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 700,
                              child: Text(
                                "Unable to get Link\nCheck internt connection",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: MihColors.secondary(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    final links = asyncSnapshot.data ?? [];

                    if (links.isEmpty) {
                      return Column(
                        children: [
                          Icon(
                            Icons.link_off,
                            size: 150,
                            color: MihColors.secondary(),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: SizedBox(
                              width: 700,
                              child: Text(
                                "No Links Available",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: MihColors.secondary(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return MihProfileLinks(
                      displayCustomName: true,
                      links: links,
                    );
                  },
                ),
              if (!widget.viewMode)
                Column(
                  children: [
                    MihProfileLinks(
                      displayCustomName: true,
                      links: profileProvider.businessLinks,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MihButton(
                          onPressed: () {
                            addProfileLinksWindow();
                          },
                          buttonColor: MihColors.green(),
                          width: profileProvider.businessLinks.isNotEmpty
                              ? 50
                              : null,
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: MihColors.primary(),
                              ),
                              if (profileProvider.businessLinks.isEmpty)
                                Text(
                                  "Add Links",
                                  style: TextStyle(
                                    color: MihColors.primary(),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        if (profileProvider.businessLinks.isNotEmpty)
                          MihButton(
                            onPressed: () {
                              manageProfileLinksWindow();
                            },
                            buttonColor: MihColors.green(),
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.edit,
                              color: MihColors.primary(),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              // Placeholder(),
            ],
          ),
        ),
      );
    });
  }
}
