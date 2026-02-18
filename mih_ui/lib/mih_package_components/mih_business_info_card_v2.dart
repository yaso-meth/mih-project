import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_add_bookmark_alert.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_delete_bookmark_alert.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_review_business_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:provider/provider.dart';
import 'package:redacted/redacted.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:url_launcher/url_launcher.dart';

class MihBusinessCardV2 extends StatefulWidget {
  final Business business;
  final double width;
  const MihBusinessCardV2({
    super.key,
    required this.business,
    required this.width,
  });

  @override
  State<MihBusinessCardV2> createState() => _MihBusinessCardV2State();
}

class _MihBusinessCardV2State extends State<MihBusinessCardV2> {
  Future<BusinessReview?>? _businessReviewFuture;
  Future<BookmarkedBusiness?>? _bookmarkedBusinessFuture;
  bool _isUserSignedIn = false;

  Future<void> _checkUserSession() async {
    final doesSessionExist = await SuperTokens.doesSessionExist();
    setState(() {
      _isUserSignedIn = doesSessionExist;
    });
  }

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
      MihAlertServices().errorBasicAlert(
        "Error Making Call",
        "We couldn't open your phone app to call $formattedNumber. To fix this, make sure you have a phone application installed and it's set as your default dialer.",
        context,
      );
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
      MihAlertServices().errorBasicAlert(
        "Error Creating Email",
        "We couldn't launch your email app to send a message to $recipient. To fix this, please confirm that you have an email application installed and that it's set as your default.",
        context,
      );
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
        MihAlertServices().errorBasicAlert(
          "Error Opening Maps",
          "There was an issue opening maps for ${widget.business.Name}. This usually happens if you don't have a maps app installed or it's not set as your default. Please install one to proceed.",
          context,
        );
      }
    } catch (e) {
      MihAlertServices().errorBasicAlert(
        "Error Opening Maps",
        "There was an issue opening maps for ${widget.business.Name}. This usually happens if you don't have a maps app installed or it's not set as your default. Please install one to proceed.",
        context,
      );
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
        MihAlertServices().errorBasicAlert(
          "Error Opening Website",
          "We couldn't open the link to $newUrl. To view this website, please ensure you have a web browser installed and set as your default.",
          context,
        );
      }
    } catch (e) {
      MihAlertServices().errorBasicAlert(
        "Error Opening Website",
        "We couldn't open the link to $newUrl. To view this website, please ensure you have a web browser installed and set as your default.",
        context,
      );
    }
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
    _checkUserSession();
    _businessReviewFuture = getUserReview();
    _bookmarkedBusinessFuture = getUserBookmark();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<MzansiProfileProvider, MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MzansiDirectoryProvider directoryProvider, Widget? child) {
        double iconSize = 50.0;
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: [
            Column(
              children: [
                MihButton(
                  width: 80,
                  height: 80,
                  onPressed: () {
                    _makePhoneCall(widget.business.contact_no);
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  child: Icon(
                    Icons.phone,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    size: iconSize,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  child: Text(
                    "Call",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                MihButton(
                  width: 80,
                  height: 80,
                  onPressed: () {
                    _launchEmail(
                      widget.business.bus_email,
                      "Inquiery about ${widget.business.Name}",
                      "Dear ${widget.business.Name},\n\nI would like to inquire about your services.\n\nBest regards,\n",
                    );
                  },
                  buttonColor: MihColors.getPinkColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  child: Icon(
                    Icons.email,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    size: iconSize,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            if (isValidGps(widget.business.gps_location))
              Column(
                children: [
                  MihButton(
                    width: 80,
                    height: 80,
                    onPressed: () {
                      final latitude = double.parse(
                          widget.business.gps_location.split(',')[0]);
                      final longitude = double.parse(
                          widget.business.gps_location.split(',')[1]);
                      _launchGoogleMapsWithUrl(
                        latitude: latitude,
                        longitude: longitude,
                      );
                    },
                    buttonColor: MihColors.getOrangeColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    child: Icon(
                      Icons.location_on,
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    child: Text(
                      "Maps",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.business.website.isNotEmpty &&
                widget.business.website != "")
              Column(
                children: [
                  MihButton(
                    width: 80,
                    height: 80,
                    onPressed: () {
                      _launchWebsite(widget.business.website);
                    },
                    buttonColor: MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    child: Icon(
                      Icons.language,
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    child: Text(
                      "Website",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            FutureBuilder(
              future: _businessReviewFuture,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      MihButton(
                        width: 80,
                        height: 80,
                        onPressed: () {},
                        buttonColor: MihColors.getGreyColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          size: iconSize,
                        ),
                      ).redacted(context: context, redact: true),
                      const SizedBox(height: 2),
                      FittedBox(
                        child: Text(
                          "Rate Us",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                          ),
                        ).redacted(context: context, redact: true),
                      ),
                    ],
                  );
                } else {
                  BusinessReview? businessReview = asyncSnapshot.data;
                  String ratingTitle = "";
                  if (businessReview == null) {
                    ratingTitle = "Rate Us";
                  } else {
                    ratingTitle = "Edit";
                  }
                  return Column(
                    children: [
                      MihButton(
                        width: 80,
                        height: 80,
                        onPressed: () {
                          businessReviewRatingWindow(directoryProvider,
                              businessReview, true, widget.width);
                        },
                        buttonColor: MihColors.getYellowColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        child: Icon(
                          Icons.star_rate_rounded,
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          size: iconSize,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        child: Text(
                          ratingTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                          ),
                        ),
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
                  return Column(
                    children: [
                      MihButton(
                        width: 80,
                        height: 80,
                        onPressed: () {},
                        buttonColor: MihColors.getGreyColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        child: Icon(
                          Icons.bookmark_add_rounded,
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          size: iconSize,
                        ),
                      ).redacted(context: context, redact: true),
                      const SizedBox(height: 2),
                      FittedBox(
                        child: Text(
                          "bookmark",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                          ),
                        ).redacted(context: context, redact: true),
                      ),
                    ],
                  );
                } else {
                  BookmarkedBusiness? bookmarkBusiness = asyncSnapshot.data;
                  String bookmarkDisplayTitle = "";
                  if (bookmarkBusiness == null) {
                    bookmarkDisplayTitle = "Bookmark";
                  } else {
                    bookmarkDisplayTitle = "Remove";
                  }
                  return Column(
                    children: [
                      MihButton(
                        width: 80,
                        height: 80,
                        onPressed: () {
                          if (bookmarkBusiness == null) {
                            showAddBookmarkAlert();
                          } else {
                            showDeleteBookmarkAlert(bookmarkBusiness);
                          }
                        },
                        buttonColor: MihColors.getBluishPurpleColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        child: Icon(
                          bookmarkBusiness == null
                              ? Icons.bookmark_add_rounded
                              : Icons.bookmark_remove_rounded,
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          size: iconSize,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        child: Text(
                          bookmarkDisplayTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> businessReviewRatingWindow(
      MzansiDirectoryProvider directoryProvider,
      BusinessReview? myReview,
      bool previouslyRated,
      double width) async {
    if (_isUserSignedIn) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MihReviewBusinessWindow(
          business: widget.business,
          businessReview: myReview,
          screenWidth: width,
          readOnly: false,
          onSuccessDismissPressed: () async {
            List<Business>? businessSearchResults = [];
            businessSearchResults = await MihBusinessDetailsServices()
                .searchBusinesses(directoryProvider.searchTerm,
                    directoryProvider.businessTypeFilter, context);
            Map<String, Future<String>> busImagesUrl = {};
            Future<String> businessLogoUrl;
            for (var bus in businessSearchResults) {
              businessLogoUrl = MihFileApi.getMinioFileUrl(bus.logo_path);
              busImagesUrl[bus.business_id] = businessLogoUrl;
            }
            directoryProvider.setSearchedBusinesses(
              searchedBusinesses: businessSearchResults,
              businessesImagesUrl: busImagesUrl,
            );
            setState(() {
              _businessReviewFuture = getUserReview();
            });
          },
        ),
      );
    } else {
      showSignInRequiredAlert();
    }
  }

  void showAddBookmarkAlert() {
    if (_isUserSignedIn) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MihAddBookmarkAlert(
          business: widget.business,
          onSuccessDismissPressed: () async {
            _bookmarkedBusinessFuture = getUserBookmark();
          },
        ),
      );
    } else {
      showSignInRequiredAlert();
    }
  }

  void showDeleteBookmarkAlert(BookmarkedBusiness? bookmarkBusiness) {
    if (_isUserSignedIn) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => MihDeleteBookmarkAlert(
                business: widget.business,
                bookmarkBusiness: bookmarkBusiness,
                onSuccessDismissPressed: () {
                  _bookmarkedBusinessFuture = getUserBookmark();
                },
                // startUpSearch: widget.startUpSearch,
              ));
    } else {
      showSignInRequiredAlert();
    }
  }

  void showSignInRequiredAlert() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: () {
            context.pop();
          },
          windowBody: Column(
            children: [
              Icon(
                MihIcons.mihLogo,
                size: 125,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              const SizedBox(height: 10),
              Text(
                "Let's Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Ready to dive in to the world of MIH?\nSign in or create a free MIH account to unlock all the powerful features of the MIH app. It's quick and easy!",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.goNamed(
                      'mihHome',
                      extra: true,
                    );
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Sign In/ Create Account",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
