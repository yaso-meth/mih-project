import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_add_bookmark_alert.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_delete_bookmark_alert.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_review_business_window.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:redacted/redacted.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:url_launcher/url_launcher.dart';

class MihBusinessCard extends StatefulWidget {
  final Business business;
  final String? startUpSearch;
  final double width;
  const MihBusinessCard({
    super.key,
    required this.business,
    required this.startUpSearch,
    required this.width,
  });

  @override
  State<MihBusinessCard> createState() => _MihBusinessCardState();
}

class _MihBusinessCardState extends State<MihBusinessCard> {
  Future<BusinessReview?>? _businessReviewFuture;
  Future<BookmarkedBusiness?>? _bookmarkedBusinessFuture;

  RedactedConfiguration getRedactedConfiguration() {
    return RedactedConfiguration(
      // redactedColor: Colors.pink,
      redactedColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    String formattedNumber = phoneNumber.replaceAll("-", "");
    final Uri url = Uri(scheme: 'tel', path: formattedNumber);
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
                color: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              alertTitle: "Error Making Call",
              alertBody: Column(
                children: [
                  Text(
                    "We couldn't open your phone app to call ${widget.business.contact_no}. To fix this, make sure you have a phone application installed and it's set as your default dialer.",
                    style: TextStyle(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              alertTitle: "Error Creating Email",
              alertBody: Column(
                children: [
                  Text(
                    "We couldn't launch your email app to send a message to ${widget.business.bus_email}. To fix this, please confirm that you have an email application installed and that it's set as your default.",
                    style: TextStyle(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                alertTitle: "Error Creating Maps",
                alertBody: Column(
                  children: [
                    Text(
                      "There was an issue opening maps for ${widget.business.Name}. This usually happens if you don't have a maps app installed or it's not set as your default. Please install one to proceed.",
                      style: TextStyle(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                alertColour: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              alertTitle: "Error Creating Maps",
              alertBody: Column(
                children: [
                  Text(
                    "There was an issue opening maps for ${widget.business.Name}. This usually happens if you don't have a maps app installed or it's not set as your default. Please install one to proceed.",
                    style: TextStyle(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                alertTitle: "Error Opening Website",
                alertBody: Column(
                  children: [
                    Text(
                      "We couldn't open the link to $newUrl. To view this website, please ensure you have a web browser installed and set as your default.",
                      style: TextStyle(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                alertColour: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              alertTitle: "Error Opening Website",
              alertBody: Column(
                children: [
                  Text(
                    "We couldn't open the link to $newUrl. To view this website, please ensure you have a web browser installed and set as your default.",
                    style: TextStyle(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              alertColour: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          });
    }
  }

  Widget _buildContactInfo(
    String label,
    String subLabel,
    IconData icon,
    Color? iconColor,
    bool redacted,
    Function()? ontap,
  ) {
    return Material(
      color: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      child: InkWell(
        onTap: ontap,
        splashColor: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark")
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
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Icon(
                    icon,
                    // size: 35,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
              ).redacted(
                context: context,
                redact: redacted,
                configuration: getRedactedConfiguration(),
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
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        height: 1.0,
                      ),
                    ).redacted(
                      context: context,
                      redact: redacted,
                      configuration: getRedactedConfiguration(),
                    ),
                    Text(
                      subLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ).redacted(
                      context: context,
                      redact: redacted,
                      configuration: getRedactedConfiguration(),
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
      widget.business.business_id,
    );
  }

  Future<BookmarkedBusiness?> getUserBookmark() async {
    String user_id = await SuperTokens.getUserId();
    return await MihMzansiDirectoryServices().getUserBookmarkOfBusiness(
      user_id,
      widget.business.business_id,
    );
  }

  bool isValidGps(String coordinateString) {
    final RegExp gpsRegex = RegExp(
        r"^-?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*-?(1[0-7]\d(\.\d+)?|180(\.0+)?|\d{1,2}(\.\d+)?)$");
    return gpsRegex.hasMatch(coordinateString);
  }

  @override
  void initState() {
    super.initState();
    _businessReviewFuture = getUserReview();
    _bookmarkedBusinessFuture = getUserBookmark();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark")
          .withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(25),
      elevation: 10,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildContactInfo(
              "Call",
              "Give us a quick call.",
              Icons.phone,
              MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              false,
              () {
                // print("Calling ${widget.cellNumber}");
                _makePhoneCall(widget.business.contact_no);
              },
            ),
            Divider(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            _buildContactInfo(
              "Email",
              "Send us an email.",
              Icons.email,
              MihColors.getPinkColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              false,
              () {
                // print("Emailing ${widget.email}");
                _launchEmail(
                  widget.business.bus_email,
                  "Inquiery about ${widget.business.Name}",
                  "Dear ${widget.business.Name},\n\nI would like to inquire about your services.\n\nBest regards,\n",
                );
              },
            ),
            Visibility(
              visible: isValidGps(widget.business.gps_location),
              child: Column(
                children: [
                  Divider(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  _buildContactInfo(
                    "Location",
                    "Come visit us.",
                    Icons.location_on,
                    MihColors.getOrangeColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    false,
                    () {
                      final latitude = double.parse(
                          widget.business.gps_location.split(',')[0]);
                      final longitude = double.parse(
                          widget.business.gps_location.split(',')[1]);
                      _launchGoogleMapsWithUrl(
                        latitude: latitude,
                        longitude: longitude,
                      );
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.business.website.isNotEmpty &&
                  widget.business.website != "",
              child: Column(
                children: [
                  Divider(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  _buildContactInfo(
                    "Website",
                    "Find out more about us.",
                    Icons.vpn_lock,
                    MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    false,
                    () {
                      _launchWebsite(widget.business.website);
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _businessReviewFuture,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  // return const SizedBox.shrink();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      Container(
                        child: _buildContactInfo(
                          "Loading Rating",
                          "Loading your rating.",
                          Icons.star_rate_rounded,
                          MihColors.getYellowColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          true,
                          null,
                        ),
                      ).redacted(context: context, redact: true),
                    ],
                  );
                } else {
                  BusinessReview? businessReview = asyncSnapshot.data;
                  String ratingDisplayTitle = "";
                  if (businessReview == null) {
                    ratingDisplayTitle = "Rate Us";
                  } else {
                    ratingDisplayTitle = "Update Rating";
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      _buildContactInfo(
                        ratingDisplayTitle,
                        "Let us know how we are doing.",
                        Icons.star_rate_rounded,
                        MihColors.getYellowColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        false,
                        () {
                          businessReviewRatingWindow(
                              businessReview, true, widget.width);
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            FutureBuilder(
              future: _bookmarkedBusinessFuture,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  // return const SizedBox.shrink();
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      Container(
                        child: _buildContactInfo(
                          "Loading Bookmark",
                          "Loading your bookmark.",
                          Icons.bookmark_add_rounded,
                          MihColors.getBluishPurpleColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          true,
                          null,
                        ),
                      ),
                    ],
                  );
                } else {
                  BookmarkedBusiness? bookmarkBusiness = asyncSnapshot.data;
                  String bookmarkDisplayTitle = "";
                  if (bookmarkBusiness == null) {
                    bookmarkDisplayTitle = "Bookmark Us";
                  } else {
                    bookmarkDisplayTitle = "Remove Bookmark";
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      _buildContactInfo(
                        bookmarkDisplayTitle,
                        "Save us for later.",
                        bookmarkBusiness == null
                            ? Icons.bookmark_add_rounded
                            : Icons.bookmark_remove_rounded,
                        MihColors.getBluishPurpleColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        false,
                        () {
                          // _launchWebsite(widget.website);
                          if (bookmarkBusiness == null) {
                            showAddBookmarkAlert();
                          } else {
                            showDeleteBookmarkAlert(bookmarkBusiness);
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Divider(
            //     color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //   ),
            // ),
            // _buildContactInfo(
            //   "Bookmark",
            //   "Save us for later.",
            //   Icons.bookmark_add_rounded,
            //   MihColors.getBluishPurpleColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //   () {
            //     // _launchWebsite(widget.website);
            //     print("Saving ${widget.business.Name} to Directory");
            //     showBookmarkAlert();
            //   },
            // ),
            const SizedBox(height: 10),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Divider(
            //     color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> businessReviewRatingWindow(
      BusinessReview? myReview, bool previouslyRated, double width) async {
    showDialog(
      context: context,
      builder: (context) => MihReviewBusinessWindow(
        business: widget.business,
        businessReview: myReview,
        screenWidth: width,
        readOnly: false,
      ),
    );
  }

  void showAddBookmarkAlert() {
    showDialog(
      context: context,
      builder: (context) => MihAddBookmarkAlert(
        business: widget.business,
      ),
    );
  }

  void showDeleteBookmarkAlert(BookmarkedBusiness? bookmarkBusiness) {
    showDialog(
        context: context,
        builder: (context) => MihDeleteBookmarkAlert(
              business: widget.business,
              bookmarkBusiness: bookmarkBusiness,
              startUpSearch: widget.startUpSearch,
            ));
  }
}
