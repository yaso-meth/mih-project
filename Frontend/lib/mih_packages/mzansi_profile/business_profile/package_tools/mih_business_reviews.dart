import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';

class MihBusinessReviews extends StatefulWidget {
  final String businessId;
  const MihBusinessReviews({
    super.key,
    required this.businessId,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MihMzansiDirectoryServices().getAllReviewsofBusiness(
          widget.businessId,
        ),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (asyncSnapshot.connectionState == ConnectionState.done &&
              asyncSnapshot.hasData) {
            List<BusinessReview> reviews = asyncSnapshot.data!;
            return ListView.separated(
              itemCount: reviews.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: RatingBar.readOnly(
                    size: 25,
                    alignment: Alignment.centerLeft,
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    halfFilledIcon: Icons.star_half,
                    filledColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    emptyColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    halfFilledColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    isHalfAllowed: true,
                    initialRating: double.parse(reviews[index].rating_score),
                    maxRating: 5,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reviews[index].rating_title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            reviews[index].rating_description,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Error'));
          }
        });
  }
}
