import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MihPersonalProfileView extends StatefulWidget {
  const MihPersonalProfileView({
    super.key,
  });

  @override
  State<MihPersonalProfileView> createState() => _MihPersonalProfileViewState();
}

class _MihPersonalProfileViewState extends State<MihPersonalProfileView> {
  late Future<List<ProfileLink>> futureLinks;
  PlatformFile? file;
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    futureLinks = MihProfileLinksServices.getUserProfileLinksMD(
        directoryProvider, directoryProvider.selectedUser!.app_id);
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      context.read<MihBannerAdProvider>().loadBannerAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    double profilePictureWidth = 150;
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        return Column(
          children: [
            Expanded(
              child: MihSingleChildScroll(
                scrollbarOn: true,
                child: Padding(
                  padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                          "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MihCircleAvatar(
                        imageFile: CachedNetworkImageProvider(
                          MihFileApi.getMinioFileUrlV2(
                            directoryProvider.selectedUser!.pro_pic_path,
                          ),
                        ),
                        width: profilePictureWidth,
                        expandable: true,
                        editable: false,
                        fileNameController: TextEditingController(),
                        userSelectedfile: file,
                        frameColor: MihColors.secondary(),
                        backgroundColor: MihColors.primary(),
                        onChange: null,
                      ),
                      FittedBox(
                        child: Text(
                          directoryProvider.selectedUser!.username.isNotEmpty
                              ? directoryProvider.selectedUser!.username
                              : "Username",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          directoryProvider.selectedUser!.fname.isNotEmpty
                              ? "${directoryProvider.selectedUser!.fname} ${directoryProvider.selectedUser!.lname}"
                              : "Name Surname",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          directoryProvider.selectedUser!.type.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: SizedBox(
                          width: 700,
                          child: Text(
                            directoryProvider.selectedUser!.purpose.isNotEmpty
                                ? directoryProvider.selectedUser!.purpose
                                : "No Personal Mission added yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MihColors.secondary(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      FutureBuilder(
                        future: futureLinks,
                        builder: (context, asyncSnapshot) {
                          final isLoading = asyncSnapshot.connectionState !=
                                  ConnectionState.done ||
                              !asyncSnapshot.hasData;
                          final links = isLoading
                              ? _dummyLinks
                              : asyncSnapshot.requireData;

                          return Skeletonizer(
                            enabled: isLoading,
                            enableSwitchAnimation: true,
                            effect: ShimmerEffect(
                              baseColor: MihColors.highlight(),
                              highlightColor: MihColors.secondary(),
                            ),
                            child: MihProfileLinks(
                              displayCustomName: true,
                              links: links,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!kIsWeb &&
                (defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS))
              MihBannerAd(),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
