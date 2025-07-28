import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_review_business_window.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';

class MihBusinessReviews extends StatefulWidget {
  final Business business;
  const MihBusinessReviews({
    super.key,
    required this.business,
  });

  @override
  State<MihBusinessReviews> createState() => _MihBusinessReviewsState();
}

class _MihBusinessReviewsState extends State<MihBusinessReviews> {
  // late Future<List<BusinessReview>> _reviews;

  // @override
  // void initState() {
  //   super.initState();
  //   _reviews = MihMzansiDirectoryServices().getAllReviewsofBusiness(
  //     widget.businessId,
  //   );
  // }

  void onReviewTap(BusinessReview? businessReview, double width) {
    // showDialog(context: context, builder: (context)=> )
    showDialog(
      context: context,
      builder: (context) {
        return MihReviewBusinessWindow(
          business: widget.business,
          businessReview: businessReview,
          screenWidth: width,
          readOnly: true,
          startUpSearch: null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: MihMzansiDirectoryServices().getAllReviewsofBusiness(
          widget.business.business_id,
        ),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (asyncSnapshot.connectionState == ConnectionState.done &&
              asyncSnapshot.hasData) {
            List<BusinessReview> reviews = asyncSnapshot.data!;
            print("Reviews: ${reviews.length}");
            if (reviews.isEmpty) {
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.star_rate_rounded,
                    size: 150,
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  Text(
                    "No reviews yet, be the first the review\n${widget.business.Name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            } else {
              int descriptionDisplayCOunt = 75;
              return ListView.separated(
                itemCount: reviews.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      onReviewTap(reviews[index], screenWidth);
                    },
                    title: RatingBar.readOnly(
                      size: 25,
                      alignment: Alignment.centerLeft,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      halfFilledIcon: Icons.star_half,
                      filledColor: MihColors.getYellowColor(context),
                      // MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      emptyColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      halfFilledColor: MihColors.getYellowColor(context),
                      // MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      // filledColor:
                      //     MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                      // emptyColor:
                      //     MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                      // halfFilledColor:
                      //     MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                      isHalfAllowed: true,
                      initialRating: double.parse(reviews[index].rating_score),
                      maxRating: 5,
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Text(
                        //   "${reviews[index].reviewer} ",
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        Text(
                          reviews[index].rating_title,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
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
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          "${reviews[index].date_time.split("T")[0]} ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          } else {
            return Center(child: Text('Error'));
          }
        });
  }
}
