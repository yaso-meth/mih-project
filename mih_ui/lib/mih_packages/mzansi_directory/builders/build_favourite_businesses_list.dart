import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_business_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:provider/provider.dart';

class BuildFavouriteBusinessesList extends StatefulWidget {
  final List<Business?> favouriteBusinesses;
  const BuildFavouriteBusinessesList({
    super.key,
    required this.favouriteBusinesses,
  });

  @override
  State<BuildFavouriteBusinessesList> createState() =>
      _BuildFavouriteBusinessesListState();
}

class _BuildFavouriteBusinessesListState
    extends State<BuildFavouriteBusinessesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        return ListView.separated(
          itemCount: widget.favouriteBusinesses.length,
          separatorBuilder: (BuildContext context, index) {
            return SizedBox(
              height: 3,
            );
          },
          itemBuilder: (context, index) {
            if (widget.favouriteBusinesses[index] == null) {
              return const SizedBox(); // Or a placeholder if a business couldn't be loaded
            }
            return Material(
              color: MihColors.secondary(),
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                hoverColor: MihColors.highlight(),
                splashColor: Color.lerp(
                  MihColors.bluishPurple(),
                  Colors.black,
                  0.01,
                ),
                title: MihBusinessProfilePreview(
                  foregroundColor: MihColors.primary(),
                  backgroundColor: MihColors.secondary(),
                  business: widget.favouriteBusinesses[index]!,
                  imageFile: CachedNetworkImageProvider(
                    MihFileApi.getMinioFileUrlV2(
                      widget.favouriteBusinesses[index]!.logo_path,
                    ),
                  ),
                  loading: false,
                ),
                onTap: () {
                  directoryProvider.setSelectedBusiness(
                    business: widget.favouriteBusinesses[index]!,
                  );
                  context.pushNamed(
                    'businessProfileView',
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
