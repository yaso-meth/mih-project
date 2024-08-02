import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MyErrorMessage extends StatefulWidget {
  final String errorType;
  const MyErrorMessage({
    super.key,
    required this.errorType,
  });

  @override
  State<MyErrorMessage> createState() => _MyErrorMessageState();
}

class _MyErrorMessageState extends State<MyErrorMessage> {
  var messageTypes = <String, Widget>{};
  // late double width = 50;
  // late double height = 50;
  Size? size;

  void setInputError() {
    messageTypes["Input Error"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 450,
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
                  size: 100,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                const SizedBox(height: 15),
                Text(
                  "Oops! Looks like some fields are missing.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "We noticed that some required fields are still empty. To ensure your request is processed smoothly, please fill out all the highlighted fields before submitting the form again.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RichText(
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

  void setPasswordRequirementsError() {
    messageTypes["Password Requirements"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 450,
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
                  size: 100,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                SizedBox(height: 15),
                Text(
                  "Password Doesn't Meet Requirements",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Oops! Your password doesn't quite meet our standards. To keep your account secure, please make sure your password meets the following requirements",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: RichText(
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
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .errorColor())),
                        const TextSpan(
                          text: "1) Contailes at least 8 characters\n",
                        ),
                        const TextSpan(
                          text:
                              "2) Contains at least 1 uppercase letter (A-Z)\n",
                        ),
                        const TextSpan(
                          text:
                              "3) Contains at least 1 lowercase letter (a-z)\n",
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

  void setUserExistsError() {
    messageTypes["User Exists"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 450,
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
                  size: 100,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                SizedBox(height: 15),
                Text(
                  "Email Already Exists",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "An account is already registered with this email address. Please try logging in or use a different email.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Here are some things to keep in mind:",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
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
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 450,
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
                  size: 100,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                SizedBox(height: 15),
                Text(
                  "Passwords Don't Match",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "The password and confirm password fields do not match. Please make sure they are identical.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Here are some things to keep in mind:",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
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

  void setinvalidCredError() {
    messageTypes["Invalid Credentials"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 450,
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
                  size: 100,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                SizedBox(height: 15),
                Text(
                  "Uh oh! Login attempt unsuccessful.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "The email address or password you entered doesn't seem to match our records. Please double-check your information and try again.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Here are some things to keep in mind:",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
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

  void setInternetError() {
    messageTypes["Internet Connection"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500,
          height: 450,
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
                  size: 100,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                const SizedBox(height: 15),
                Text(
                  "Internet Connection Lost!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "We seem to be having some trouble connecting you to the internet. This could be due to a temporary outage or an issue with your device's connection.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "Here are a few things you can try:",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "1) Check your Wi-Fi signal strength or try connecting to a different network.\n2) Restart your device (computer, phone, etc.) and your router/modem.\n3) If you're using cellular data, ensure you have a strong signal and haven't reached your data limit.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
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

  Widget? getErrorMessage(String type) {
    return messageTypes[type];
  }

  // void initialiseSizes() {

  // }

  // @override
  // void initState() {
  //   size = MediaQuery.of(context).size;
  //   setInputError();
  //   setinvalidCredError();
  //   setInternetError();
  //   //initialiseSizes();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    setInputError();
    setinvalidCredError();
    setInternetError();
    setUserExistsError();
    setPwdMatchError();
    setPasswordRequirementsError();
    //print(size);
    // setState(() {
    //   width = size.width;
    //   height = size.height;
    // });
    return Dialog(child: getErrorMessage(widget.errorType));
  }
}
