import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_review_business_window.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';

class MihBusinessReviews extends StatefulWidget {
  final Business? business;
  const MihBusinessReviews({
    super.key,
    required this.business,
  });

  @override
  State<MihBusinessReviews> createState() => _MihBusinessReviewsState();
}

class _MihBusinessReviewsState extends State<MihBusinessReviews> {
  late Business business;
  late List<BusinessReview> reviews;

  @override
  void initState() {
    super.initState();
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    if (widget.business != null) {
      business = widget.business!;
      reviews = []; //Update later
    } else {
      business = profileProvider.business!;
      reviews = profileProvider.businessReviews;
    }
  }

  void onReviewTap(BusinessReview? businessReview, double width) {
    // showDialog(context: context, builder: (context)=> )
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihReviewBusinessWindow(
          business: business,
          businessReview: businessReview,
          screenWidth: width,
          readOnly: true,
          onSuccessDismissPressed: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Icon(
                    MihIcons.mihRing,
                    size: 165,
                    color: MihColors.secondary(),
                  ),
                ),
                Icon(
                  Icons.star_rate_rounded,
                  size: 150,
                  color: MihColors.secondary(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "No reviews yet, be the first the review ${business.Name}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.secondary(),
              ),
            ),
          ],
        ),
      );
    } else {
      int descriptionDisplayCOunt = 75;
      return ListView.separated(
        itemCount: reviews.length,
        separatorBuilder: (context, index) => SizedBox(height: 3),
        itemBuilder: (context, index) {
          Future<AppUser?> reviewer =
              MihUserServices().getMIHUserDetailsV2(reviews[index].app_id);
          return Material(
            color: MihColors.secondary(),
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              splashColor: Color.lerp(
                MihColors.bluishPurple(),
                Colors.black,
                0.01,
              ),
              hoverColor: MihColors.highlight(),
              leading: FutureBuilder<AppUser?>(
                future: reviewer,
                builder: (context, snapshot) {
                  ImageProvider? image;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    image = null;
                  }

                  if (snapshot.hasData) {
                    String? userPicUrl = MihFileApi.getMinioFileUrlV2(
                        snapshot.data!.pro_pic_path);
                    image = CachedNetworkImageProvider(userPicUrl);
                  }

                  if (snapshot.hasError) {
                    image = null;
                  }

                  return MihCircleAvatar(
                    imageFile: image,
                    width: 50,
                    expandable: true,
                    editable: false,
                    fileNameController: null,
                    userSelectedfile: null,
                    frameColor: MihColors.primary(),
                    backgroundColor: MihColors.secondary(),
                    onChange: null,
                  );
                },
              ),
              onTap: () {
                onReviewTap(reviews[index], screenWidth);
              },
              title: RatingBar.readOnly(
                size: 25,
                alignment: Alignment.centerLeft,
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                halfFilledIcon: Icons.star_half,
                filledColor: MihColors.yellow(darkMode: false),
                emptyColor: MihColors.secondary(),
                halfFilledColor: MihColors.yellow(darkMode: false),
                isHalfAllowed: true,
                initialRating: double.parse(reviews[index].rating_score),
                maxRating: 5,
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    reviews[index].rating_title,
                    softWrap: true,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: MihColors.primary(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Visibility(
                    visible: reviews[index].rating_description.isNotEmpty,
                    child: Text(
                      reviews[index].rating_description.isEmpty
                          ? ""
                          : "${reviews[index].rating_description.substring(0, reviews[index].rating_description.length >= descriptionDisplayCOunt ? descriptionDisplayCOunt : reviews[index].rating_description.length - 1)}${reviews[index].rating_description.length >= descriptionDisplayCOunt ? "..." : ""}",
                      style: TextStyle(
                        fontSize: 18,
                        color: MihColors.primary(),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    "${reviews[index].date_time.split("T")[0]} ",
                    style: TextStyle(
                      fontSize: 15,
                      color: MihColors.primary(),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
