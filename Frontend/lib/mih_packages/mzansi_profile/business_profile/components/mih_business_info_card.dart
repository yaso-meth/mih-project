import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_review_business_window.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:url_launcher/url_launcher.dart';

class MihBusinessCard extends StatefulWidget {
  final String businessid;
  final String businessName;
  final String cellNumber;
  final String email;
  final String gpsLocation;
  final String? website;
  final double rating;
  final double width;
  const MihBusinessCard({
    super.key,
    required this.businessid,
    required this.businessName,
    required this.cellNumber,
    required this.email,
    required this.gpsLocation,
    required this.rating,
    this.website,
    required this.width,
  });

  @override
  State<MihBusinessCard> createState() => _MihBusinessCardState();
}

class _MihBusinessCardState extends State<MihBusinessCard> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return MihPackageAlert(
              alertIcon: Icon(
                Icons.warning_rounded,
                size: 100,
                color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              ),
              alertTitle: "Error Making Call",
              alertBody: Column(
                children: [
                  Text(
                    "We couldn't open your phone app to call ${widget.cellNumber}. To fix this, make sure you have a phone application installed and it's set as your default dialer.",
                    style: TextStyle(
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
            );
          });
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _launchEmail(
      String recipient, String subject, String body) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipient,
      query: _encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return MihPackageAlert(
              alertIcon: Icon(
                Icons.warning_rounded,
                size: 100,
                color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              ),
              alertTitle: "Error Creating Email",
              alertBody: Column(
                children: [
                  Text(
                    "We couldn't launch your email app to send a message to ${widget.email}. To fix this, please confirm that you have an email application installed and that it's set as your default.",
                    style: TextStyle(
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
            );
          });
    }
  }

  Future<void> _launchGoogleMapsWithUrl({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude${label != null ? '&query_place_id=' : ''}',
    );
    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return MihPackageAlert(
                alertIcon: Icon(
                  Icons.warning_rounded,
                  size: 100,
                  color: MzansiInnovationHub.of(context)!.theme.errorColor(),
                ),
                alertTitle: "Error Creating Maps",
                alertBody: Column(
                  children: [
                    Text(
                      "There was an issue opening maps for ${widget.businessName}. This usually happens if you don't have a maps app installed or it's not set as your default. Please install one to proceed.",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                alertColour:
                    MzansiInnovationHub.of(context)!.theme.errorColor(),
              );
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return MihPackageAlert(
              alertIcon: Icon(
                Icons.warning_rounded,
                size: 100,
                color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              ),
              alertTitle: "Error Creating Maps",
              alertBody: Column(
                children: [
                  Text(
                    "There was an issue opening maps for ${widget.businessName}. This usually happens if you don't have a maps app installed or it's not set as your default. Please install one to proceed.",
                    style: TextStyle(
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
            );
          });
    }
  }

  Future<void> _launchWebsite(String urlString) async {
    String newUrl = urlString;
    if (!newUrl.startsWith("https://")) {
      newUrl = "https://$urlString";
    }
    final Uri url = Uri.parse(newUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('Could not launch $urlString');
        showDialog(
            context: context,
            builder: (context) {
              return MihPackageAlert(
                alertIcon: Icon(
                  Icons.warning_rounded,
                  size: 100,
                  color: MzansiInnovationHub.of(context)!.theme.errorColor(),
                ),
                alertTitle: "Error Opening Website",
                alertBody: Column(
                  children: [
                    Text(
                      "We couldn't open the link to $newUrl. To view this website, please ensure you have a web browser installed and set as your default.",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                alertColour:
                    MzansiInnovationHub.of(context)!.theme.errorColor(),
              );
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return MihPackageAlert(
              alertIcon: Icon(
                Icons.warning_rounded,
                size: 100,
                color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              ),
              alertTitle: "Error Opening Website",
              alertBody: Column(
                children: [
                  Text(
                    "We couldn't open the link to $newUrl. To view this website, please ensure you have a web browser installed and set as your default.",
                    style: TextStyle(
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
            );
          });
    }
  }

  Widget _buildContactInfo(
    String label,
    String subLabel,
    IconData icon,
    Color? iconColor,
    Function()? ontap,
  ) {
    return Material(
      color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
      child: InkWell(
        onTap: ontap,
        splashColor: MzansiInnovationHub.of(context)!
            .theme
            .primaryColor()
            .withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            // vertical: 5,
            horizontal: 25,
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  icon,
                  size: 35,
                  color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        height: 1.0,
                      ),
                    ),
                    Text(
                      subLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<BusinessReview?> getUserReview() async {
    String user_id = await SuperTokens.getUserId();
    return await MihMzansiDirectoryServices().getUserReviewOfBusiness(
      user_id,
      widget.businessid,
    );
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: MzansiInnovationHub.of(context)!
          .theme
          .secondaryColor()
          .withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(25),
      elevation: 10,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            RatingBar.readOnly(
              size: 50,
              alignment: Alignment.center,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              halfFilledIcon: Icons.star_half,
              filledColor:
                  MzansiInnovationHub.of(context)!.theme.primaryColor(),
              emptyColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              halfFilledColor:
                  MzansiInnovationHub.of(context)!.theme.primaryColor(),
              isHalfAllowed: true,
              initialRating: widget.rating,
              maxRating: 5,
            ),
            // Text(
            //   "Rating: ${widget.rating}",
            //   style: TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //     color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            //     height: 1.0,
            //   ),
            // ),
            // Divider(
            //   color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            // ),
            const SizedBox(height: 10),
            _buildContactInfo(
              "Call",
              "Give us a quick call.",
              Icons.phone,
              const Color(0xffaff0b3),
              () {
                // print("Calling ${widget.cellNumber}");
                _makePhoneCall(widget.cellNumber);
              },
            ),
            Divider(
              color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            ),
            _buildContactInfo(
              "Email",
              "Send us an email.",
              Icons.email,
              const Color(0xffdaa2e9),
              () {
                // print("Emailing ${widget.email}");
                _launchEmail(
                  widget.email,
                  "Inquiery about ${widget.businessName}",
                  "Dear ${widget.businessName},\n\nI would like to inquire about your services.\n\nBest regards,\n",
                );
              },
            ),
            Divider(
              color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            ),
            _buildContactInfo(
              "Location",
              "Come visit us.",
              Icons.location_on,
              const Color(0xffd69d7d),
              () {
                final latitude = double.parse(widget.gpsLocation.split(',')[0]);
                final longitude =
                    double.parse(widget.gpsLocation.split(',')[1]);
                _launchGoogleMapsWithUrl(
                  latitude: latitude,
                  longitude: longitude,
                );
              },
            ),
            Visibility(
              visible: widget.website != null && widget.website! != "",
              child: Divider(
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
            Visibility(
              visible: widget.website != null && widget.website! != "",
              child: _buildContactInfo(
                "Website",
                "Find out more about us.",
                Icons.vpn_lock,
                const Color(0xffd67d8a),
                () {
                  _launchWebsite(widget.website!);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
            _buildContactInfo(
              "Rate Us",
              "Let us know how we are doing.",
              Icons.star_rate_rounded,
              const Color(0xffe9e8a1),
              () {
                businessReviewRatingWindow(true, widget.width);
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Divider(
            //     color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            //   ),
            // ),
            // _buildContactInfo(
            //   "Bookmark",
            //   "Save us for later.",
            //   Icons.bookmark_add_rounded,
            //   const Color(0xff6e7dcc),
            //   () {
            //     // _launchWebsite(widget.website);
            //     print("Saving ${widget.businessName} to Directory");
            //   },
            // ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Divider(
            //     color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> businessReviewRatingWindow(
      bool previouslyRated, double width) async {
    showDialog(
      context: context,
      builder: (context) => FutureBuilder(
        future: getUserReview(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle(
              message: "Checking for previous reviews...",
            );
          } else if (asyncSnapshot.connectionState == ConnectionState.done) {
            return MihReviewBusinessWindow(
              businessId: widget.businessid,
              businessReview: asyncSnapshot.data,
              screenWidth: width,
            );
          } else {
            return MihPackageAlert(
              alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
              alertIcon: Icon(
                Icons.warning_rounded,
                size: 100,
                color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              ),
              alertTitle: "Error Pulling Data",
              alertBody: Column(
                children: [
                  Text(
                    "Please ensure you are connectede top the internet and you are running the latest version of MIH then try again.",
                    style: TextStyle(
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
