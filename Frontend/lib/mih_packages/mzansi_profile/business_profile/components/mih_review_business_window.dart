import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_review.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MihReviewBusinessWindow extends StatefulWidget {
  final Business business;
  final BusinessReview? businessReview;
  final double screenWidth;
  final bool readOnly;
  const MihReviewBusinessWindow({
    super.key,
    required this.business,
    required this.businessReview,
    required this.screenWidth,
    required this.readOnly,
  });

  @override
  State<MihReviewBusinessWindow> createState() =>
      _MihReviewBusinessWindowState();
}

class _MihReviewBusinessWindowState extends State<MihReviewBusinessWindow> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewTitleController = TextEditingController();
  final TextEditingController _reviewScoreController = TextEditingController();
  final TextEditingController _reviewReviewerController =
      TextEditingController();
  final TextEditingController _reviewDescriptionController =
      TextEditingController();
  late final VoidCallback _reviewDescriptionListener;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  String userId = "";

  void showDeleteReviewAlert() {
    showDialog(
      context: context,
      builder: (context) => MihPackageAlert(
        alertColour: MihColors.getRedColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        alertIcon: Icon(
          Icons.warning_rounded,
          size: 100,
          color: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
        alertTitle: "Delete Review",
        alertBody: Column(
          children: [
            Text(
              "Are you sure you want to delete this review? This action cannot be undone.",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MihButton(
                  width: 300,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Mihloadingcircle();
                      },
                    );
                    await MihMzansiDirectoryServices()
                        .deleteBusinessReview(
                      widget.businessReview!.idbusiness_ratings,
                      widget.businessReview!.business_id,
                      widget.businessReview!.rating_score,
                      widget.business.rating,
                    )
                        .then((statusCode) {
                      context.pop(); //Remove loading dialog
                      context.pop(); //Remove delete dialog
                      if (statusCode == 200) {
                        context.pop(); //Remove window
                        successPopUp(
                          "Successfully Deleted Review!",
                          "Your review has successfully been delete and will no longer appear under the business.",
                        );
                      } else {
                        MihAlertServices().errorAlert(
                          "Error Deleting Review",
                          "There was an error deleting your review. Please try again later.",
                          context,
                        );
                      }
                    });
                  },
                  buttonColor: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MihButton(
                  width: 300,
                  onPressed: () {
                    context.pop();
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getMissionVisionLimitColor(int limit) {
    if (_counter.value <= limit) {
      return MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    } else {
      return MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }
  }

  void submitForm() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    if (widget.businessReview != null) {
      await MihMzansiDirectoryServices()
          .updateBusinessReview(
        widget.businessReview!.idbusiness_ratings,
        widget.businessReview!.business_id,
        _reviewTitleController.text,
        _reviewDescriptionController.text,
        _reviewScoreController.text,
        widget.businessReview!.rating_score,
        widget.business.rating,
      )
          .then((statusCode) {
        context.pop(); //Remove loading dialog
        if (statusCode == 200) {
          context.pop();
          successPopUp(
            "Successfully Updated Review!",
            "Your review has successfully been updated and will now appear under the business.",
          );
        } else {
          MihAlertServices().errorAlert(
            "Error Updating Review",
            "There was an error updating your review. Please try again later.",
            context,
          );
        }
      });
    } else {
      await MihMzansiDirectoryServices()
          .addBusinessReview(
        userId,
        widget.business.business_id,
        _reviewTitleController.text,
        _reviewDescriptionController.text,
        _reviewScoreController.text,
        widget.business.rating.isEmpty ? "0.0" : widget.business.rating,
      )
          .then((statusCode) {
        context.pop(); //Remove loading dialog
        if (statusCode == 201) {
          context.pop();
          successPopUp(
            "Successfully Added Review!",
            "Your review has successfully been added and will now appear under the business.",
          );
        } else {
          MihAlertServices().errorAlert(
            "Error Adding Review",
            "There was an error adding your review. Please try again later.",
            context,
          );
        }
      });
    }
  }

  void successPopUp(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.goNamed(
                      "mzansiDirectory",
                      extra: MzansiDirectoryArguments(
                        personalSearch: false,
                        startSearchText: widget.business.Name,
                      ),
                    );
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
        // return MIHSuccessMessage(
        //   successType: "Success",
        //   successMessage: message,
        // );
      },
    );
  }

  String getWindowTitle() {
    if (widget.readOnly) {
      return "Review Details";
    } else if (widget.businessReview != null) {
      return "Update Review";
    } else {
      return "Add Review";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _reviewDescriptionController.removeListener(_reviewDescriptionListener);
  }

  @override
  void initState() {
    super.initState();
    _reviewDescriptionListener = () {
      setState(() {
        _counter.value = _reviewDescriptionController.text.characters.length;
      });
    };
    _reviewDescriptionController.addListener(_reviewDescriptionListener);
    if (widget.businessReview != null) {
      setState(() {
        _reviewTitleController.text = widget.businessReview!.rating_title;
        _reviewDescriptionController.text =
            widget.businessReview!.rating_description;
        _reviewScoreController.text = widget.businessReview!.rating_score;
        _reviewReviewerController.text = widget.businessReview!.reviewer;
      });
    } else {
      _reviewScoreController.text = "1.0"; // Default score
    }
    SuperTokens.getUserId().then((value) {
      setState(() {
        userId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: getWindowTitle(),
      onWindowTapClose: () {
        Navigator.of(context).pop();
      },
      menuOptions: widget.businessReview != null && !widget.readOnly
          ? [
              SpeedDialChild(
                child: Icon(
                  Icons.delete,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "Delete Review",
                labelBackgroundColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                labelStyle: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                onTap: () {
                  showDeleteReviewAlert();
                },
              ),
            ]
          : null,
      windowBody: MihSingleChildScroll(
        child: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.05)
                  : EdgeInsets.symmetric(horizontal: widget.screenWidth * 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Business Rating",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  widget.readOnly
                      ? RatingBar.readOnly(
                          size: 50,
                          alignment: Alignment.centerLeft,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          halfFilledIcon: Icons.star_half,
                          filledColor: MihColors.getYellowColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          // filledColor: MzansiInnovationHub.of(context)!
                          //     .theme
                          //     .secondaryColor(),
                          emptyColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          halfFilledColor: MihColors.getYellowColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          // MzansiInnovationHub.of(context)!
                          //     .theme
                          //     .secondaryColor(),
                          isHalfAllowed: true,
                          initialRating: widget.businessReview != null
                              ? double.parse(_reviewScoreController.text)
                              : 1,
                          maxRating: 5,
                        )
                      : RatingBar(
                          size: 50,
                          alignment: Alignment.centerLeft,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          halfFilledIcon: Icons.star_half,
                          filledColor: MihColors.getYellowColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          emptyColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          halfFilledColor: MihColors.getYellowColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          isHalfAllowed: true,
                          initialRating: widget.businessReview != null
                              ? double.parse(_reviewScoreController.text)
                              : 1,
                          maxRating: 5,
                          onRatingChanged: (double) {
                            setState(() {
                              _reviewScoreController.text =
                                  double.toStringAsFixed(1);
                            });
                            print(_reviewScoreController.text);
                          },
                        ),
                  Visibility(
                    visible: widget.readOnly,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: widget.readOnly,
                    child: MihTextFormField(
                      // width: 200,
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: _reviewReviewerController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "Reviewer",
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  MihTextFormField(
                    // width: 200,
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: _reviewTitleController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: widget.readOnly,
                    hintText: "Review Title",
                    validator: (value) {
                      return MihValidationServices()
                          .isEmpty(_reviewTitleController.text);
                    },
                  ),
                  const SizedBox(height: 10),
                  MihTextFormField(
                    height: 250,
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: _reviewDescriptionController,
                    multiLineInput: true,
                    requiredText: widget.readOnly,
                    readOnly: widget.readOnly,
                    hintText: "Review Description",
                    validator: (value) {
                      if (_reviewDescriptionController.text.isEmpty) {
                        return null;
                      } else {
                        return MihValidationServices().validateLength(
                            _reviewDescriptionController.text, 256);
                      }
                    },
                  ),
                  Visibility(
                    visible: !widget.readOnly,
                    child: SizedBox(
                      height: 15,
                      child: ValueListenableBuilder(
                        valueListenable: _counter,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$value",
                                style: TextStyle(
                                  color: getMissionVisionLimitColor(256),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "/256",
                                style: TextStyle(
                                  color: getMissionVisionLimitColor(256),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Visibility(
                    visible: !widget.readOnly,
                    child: Center(
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitForm();
                          } else {
                            MihAlertServices().formNotFilledCompletely(context);
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          widget.businessReview != null
                              ? "Update Review"
                              : "Add Review",
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
