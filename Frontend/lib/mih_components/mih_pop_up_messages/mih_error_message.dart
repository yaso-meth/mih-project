import 'package:flutter/material.dart';
import '../../main.dart';

class MIHErrorMessage extends StatefulWidget {
  final String errorType;
  const MIHErrorMessage({
    super.key,
    required this.errorType,
  });

  @override
  State<MIHErrorMessage> createState() => _MIHErrorMessageState();
}

class _MIHErrorMessageState extends State<MIHErrorMessage> {
  var messageTypes = <String, Widget>{};
  late double popUpWidth;
  late double? popUpheight;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  Size? size;

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (size!.width / 4) * 2;
        popUpheight = null;
        popUpTitleSize = 25.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 25.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = size!.width - (size!.width * 0.1);
        popUpheight = null;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 15.0;
        popUpIconSize = 100;
      });
    }
  }

  void setInputError() {
    messageTypes["Input Error"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //const SizedBox(height: 5),
                Text(
                  "Oops! Looks like some fields are missing.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "We noticed that some required fields are still empty. To ensure your request is processed smoothly, please fill out all the highlighted fields before submitting the form again.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: popUpBodySize,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Here's a quick tip: ",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .errorColor())),
                      const TextSpan(
                          text: "Look for fields with an asterisk ("),
                      TextSpan(
                          text: "*",
                          style: TextStyle(
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .errorColor())),
                      const TextSpan(
                          text: ") next to them, as these are mandatory."),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setPasswordRequirementsError() {
    messageTypes["Password Requirements"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Password Doesn't Meet Requirements",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Oops! Your password doesn't quite meet our standards. To keep your account secure, please make sure your password meets the following requirements",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Requirements:\n",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: popUpBodySize,
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .errorColor())),
                      const TextSpan(
                        text: "1) Contailes at least 8 characters\n",
                      ),
                      const TextSpan(
                        text: "2) Contains at least 1 uppercase letter (A-Z)\n",
                      ),
                      const TextSpan(
                        text: "3) Contains at least 1 lowercase letter (a-z)\n",
                      ),
                      const TextSpan(
                        text: "4) Contains at least 1 number (0-9)\n",
                      ),
                      const TextSpan(
                        text:
                            "5) Contains at least 1 special character (!@#\$%^&*)\n",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setInvalidUsernameError() {
    messageTypes["Invalid Username"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Let's Fix That Username",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Let's create a great username for you! Just a few quick tips:\n• Your username should start with a letter.\n• You can use letters, numbers, and/ or underscores.\n• Keep it between 6 and 20 characters.\n• Avoid special characters like @, #, or \$.\"",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setInvalidEmailError() {
    messageTypes["Invalid Email"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Oops! Invalid Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Looks like there's a little hiccup with that email address. Please double-check that you've entered it correctly, including the \"@\" symbol and a domain (like example@email.com).",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setUserExistsError() {
    messageTypes["User Exists"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //SizedBox(height: 15),
                Text(
                  "Email Already Exists",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "An account is already registered with this email address. Please try logging in or use a different email.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Here are some things to keep in mind:",
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpSubtitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setPwdMatchError() {
    messageTypes["Password Match"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //SizedBox(height: 15),
                Text(
                  "Passwords Don't Match",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "The password and confirm password fields do not match. Please make sure they are identical.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Here are some things to keep in mind:",
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpSubtitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setinvalidCredError() {
    messageTypes["Invalid Credentials"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //SizedBox(height: 15),
                Text(
                  "Uh oh! Login attempt unsuccessful.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "The email address or password you entered doesn't seem to match our records. Please double-check your information and try again.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Here are some things to keep in mind:",
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpSubtitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setInternetError() {
    messageTypes["Internet Connection"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Internet Connection Lost!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "We seem to be having some trouble connecting you to the internet. This could be due to a temporary outage or an issue with your device's connection.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Here are a few things you can try:",
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpSubtitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "1) Check your Wi-Fi signal strength or try connecting to a different network.\n2) Restart your device (computer, phone, etc.) and your router/modem.\n3) If you're using cellular data, ensure you have a strong signal and haven't reached your data limit.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setLocationError() {
    messageTypes["Location Denied"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Location Services Not Enabled",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "To get the most out of MIH, we need your location. Please go to the site settings of the app and enable location services. Once you do that, we can start showing you relevant information based on your location.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 15),
                // Text(
                //   "Here are a few things you can try:",
                //   style: TextStyle(
                //     color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                //     fontSize: popUpSubtitleSize,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Text(
                //   "1) Check your Wi-Fi signal strength or try connecting to a different network.\n2) Restart your device (computer, phone, etc.) and your router/modem.\n3) If you're using cellular data, ensure you have a strong signal and haven't reached your data limit.",
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     color:
                //         MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                //     fontSize: popUpBodySize,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  Widget? getErrorMessage(String type) {
    return messageTypes[type];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    checkScreenSize();
    setInputError();
    setinvalidCredError();
    setInternetError();
    setUserExistsError();
    setPwdMatchError();
    setPasswordRequirementsError();
    setInvalidEmailError();
    setInvalidUsernameError();
    setLocationError();
    //print(size);
    // setState(() {
    //   width = size.width;
    //   height = size.height;
    // });
    return Dialog(child: getErrorMessage(widget.errorType));
  }
}
