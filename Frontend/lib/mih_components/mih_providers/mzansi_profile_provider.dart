import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/user_consent.dart';

class MzansiProfileProvider extends ChangeNotifier {
  bool personalHome;
  int personalIndex;
  int businessIndex;
  AppUser? user;
  String? userProfilePicUrl;
  ImageProvider<Object>? userProfilePicture;
  Business? business;
  String? businessProfilePicUrl;
  ImageProvider<Object>? businessProfilePicture;
  BusinessUser? businessUser;
  String? businessUserSignatureUrl;
  ImageProvider<Object>? businessUserSignature;
  UserConsent? userConsent;
  List<BusinessEmployee>? employeeList;

  MzansiProfileProvider({
    this.personalHome = true,
    this.personalIndex = 0,
    this.businessIndex = 0,
  });

  void reset() {
    personalHome = true;
    personalIndex = 0;
    businessIndex = 0;
    user = null;
    userProfilePicUrl = null;
    userProfilePicture = null;
    business = null;
    businessProfilePicUrl = null;
    businessProfilePicture = null;
    businessUser = null;
    businessUserSignatureUrl = null;
    businessUserSignature = null;
    userConsent = null;
  }

  void setPersonalIndex(int index) {
    personalIndex = index;
    notifyListeners();
  }

  void setBusinessIndex(int index) {
    businessIndex = index;
    notifyListeners();
  }

  void setUser({
    required AppUser newUser,
  }) {
    user = newUser;
    notifyListeners();
  }

  void setUserProfilePicUrl(String url) {
    userProfilePicUrl = url;
    userProfilePicture = url.isNotEmpty ? NetworkImage(url) : null;
    notifyListeners();
  }

  void setBusiness({
    Business? newBusiness,
  }) {
    business = newBusiness;
    notifyListeners();
  }

  void setBusinessProfilePicUrl(String url) {
    businessProfilePicUrl = url;
    businessProfilePicture = url.isNotEmpty ? NetworkImage(url) : null;
    notifyListeners();
  }

  void setBusinessUser({required BusinessUser newBusinessUser}) {
    businessUser = newBusinessUser;
    notifyListeners();
  }

  void setBusinessUserSignatureUrl(String url) {
    businessUserSignatureUrl = url;
    businessUserSignature = url.isNotEmpty ? NetworkImage(url) : null;
    notifyListeners();
  }

  void setUserConsent(UserConsent? newUserConsent) {
    userConsent = newUserConsent;
    notifyListeners();
  }

  void setEmployeeList({required List<BusinessEmployee> employeeList}) {
    this.employeeList = employeeList;
    notifyListeners();
  }

  void addLoyaltyCard({required BusinessEmployee newEmployee}) {
    employeeList!.add(newEmployee);
    notifyListeners();
  }

  void updateEmplyeeDetails({required BusinessEmployee updatedEmployee}) {
    int index = employeeList!.indexWhere((employee) =>
        employee.business_id == updatedEmployee.business_id &&
        employee.app_id == updatedEmployee.app_id);
    if (index != -1) {
      employeeList![index] = updatedEmployee;
      notifyListeners();
    }
  }

  void deleteEmplyee({required BusinessEmployee deletedEmployee}) {
    employeeList!.removeWhere((employee) =>
        employee.business_id == deletedEmployee.business_id &&
        employee.app_id == deletedEmployee.app_id);
    notifyListeners();
  }

  void addEmployee({required BusinessEmployee newEmployee}) {
    employeeList!.add(newEmployee);
    notifyListeners();
  }
}
