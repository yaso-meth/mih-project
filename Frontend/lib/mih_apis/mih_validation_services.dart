class MihValidationServices {
  String? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? validateLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (value.length > maxLength) {
      return "Length must not exceed $maxLength characters";
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return "Invalid Email Format";
    }
    return null;
  }

  String? validateUsername(String? username) {
    String? errorMessage = "";
    if (username == null || username.isEmpty) {
      errorMessage += "Username is required";
      return errorMessage;
    }
    if (!RegExp(r'^[a-zA-Z]').hasMatch(username)) {
      errorMessage += "\n• Your username should start with a letter.";
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      errorMessage +=
          "\n• You can use letters, numbers, and/or underscores only.";
    }
    if (username.length < 6 || username.length > 30) {
      errorMessage += "\n• Keep it between 6 and 30 characters.";
    }
    if (RegExp(r'[@#\$]').hasMatch(username)) {
      errorMessage += "\n• Avoid special characters like @, #, or \$.";
    }

    if (errorMessage.isEmpty) {
      return null; // No errors, username is valid
    }
    return "Let's create a great username for you!$errorMessage";
  }

  String? validateNumber(String? number, int? minValue, int? maxValue) {
    String? errorMessage = "";
    if (number == null || number.isEmpty) {
      errorMessage += "This field is required";
      return errorMessage;
    }
    int? value = int.tryParse(number);
    if (value == null) {
      errorMessage += "Please enter a valid number";
      return errorMessage;
    }
    if (value < (minValue ?? 0)) {
      errorMessage += "Value must be >= ${minValue ?? 0}";
    }
    if (maxValue != null && value > maxValue) {
      if (errorMessage.isNotEmpty) errorMessage += "\n";
      errorMessage += "Value must be <= $maxValue";
    }
    return errorMessage.isEmpty ? null : errorMessage;
  }

  String? validatePassword(String? password) {
    String? errorMessage = "";
    if (password == null || password.isEmpty) {
      errorMessage += "Password is required";
      return errorMessage;
    }
    if (password.length < 8) {
      errorMessage += "\n• Contains at least 8 characters long";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errorMessage += "\n• Contains at least 1 uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      errorMessage += "\n• Contains at least 1 lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      errorMessage += "\n• Contains at least 1 digit";
    }
    if (!RegExp(r'[!@#$%^&*]').hasMatch(password)) {
      errorMessage += "\n• Contains at least 1 special character (!@#\$%^&*)";
    }
    if (errorMessage.isEmpty) {
      return null; // No errors, password is valid
    }
    errorMessage = "Let's create a great password for you!$errorMessage";
    return errorMessage;
  }
}
