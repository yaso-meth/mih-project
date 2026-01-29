import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_business_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
            return Divider(
              color: Theme.of(context).colorScheme.secondary,
            );
          },
          itemBuilder: (context, index) {
            if (widget.favouriteBusinesses[index] == null) {
              return const SizedBox(); // Or a placeholder if a business couldn't be loaded
            }
            return Material(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              child: InkWell(
                onTap: () {
                  directoryProvider.setSelectedBusiness(
                    business: widget.favouriteBusinesses[index]!,
                  );
                  context.pushNamed(
                    'businessProfileView',
                  );
                },
                splashColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: FutureBuilder(
                      future: directoryProvider.favBusImagesUrl![
                          widget.favouriteBusinesses[index]!.business_id],
                      builder: (context, asyncSnapshot) {
                        ImageProvider<Object>? imageFile;
                        bool loading = true;
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.done) {
                          loading = false;
                          if (asyncSnapshot.hasData) {
                            imageFile = asyncSnapshot.requireData != ""
                                ? CachedNetworkImageProvider(
                                    asyncSnapshot.requireData)
                                : null;
                          } else {
                            imageFile = null;
                          }
                        } else {
                          imageFile = null;
                        }
                        return MihBusinessProfilePreview(
                          business: widget.favouriteBusinesses[index]!,
                          imageFile: imageFile,
                          loading: loading,
                        );
                      }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
