import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/mzansi_profile_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';

class MzansiProfileProvider extends ChangeNotifier {
  final MzansiProfileHiveData _hiveData;

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
  List<AppUser> userSearchResults = [];
  bool hideBusinessUserDetails;
  List<ProfileLink> personalLinks = [];
  List<ProfileLink> businessLinks = [];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  MzansiProfileProvider(
    this._hiveData, {
    this.personalHome = true,
    this.personalIndex = 0,
    this.businessIndex = 0,
    this.hideBusinessUserDetails = true,
  });

  void loadCachedProfileState() {
    user = _hiveData.getCachedUser();
    userConsent = _hiveData.getCachedConsent();
    business = _hiveData.getCachedBusiness();
    businessUser = _hiveData.getCachedBusinessUser();
    if (user != null && user!.pro_pic_path.isNotEmpty) {
      KenLogger.success("proPicPath: ${user!.pro_pic_path}| THis is it");
      userProfilePicUrl = MihFileApi.getMinioFileUrlV2(user!.pro_pic_path);
      userProfilePicture = CachedNetworkImageProvider(userProfilePicUrl!);
    }
    if (business != null && business!.logo_path.isNotEmpty) {
      businessProfilePicUrl = MihFileApi.getMinioFileUrlV2(business!.logo_path);
      businessProfilePicture =
          CachedNetworkImageProvider(businessProfilePicUrl!);
    }
    if (businessUser != null && businessUser!.sig_path.isNotEmpty) {
      businessUserSignatureUrl =
          MihFileApi.getMinioFileUrlV2(businessUser!.sig_path);
      businessUserSignature =
          CachedNetworkImageProvider(businessUserSignatureUrl!);
    }

    employeeList = _hiveData.getCachedBusinessEmployees();

    personalLinks = _hiveData.getCachedPersonalProfileLinks();

    businessLinks = _hiveData.getCachedBusinessProfileLinks();

    KenLogger.success("Mzansi Profile Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData() async {
    bool success = await _hiveData.syncProfileDataWithServer();
    loadCachedProfileState();
    return success;
  }

  void triggerRefresh() {
    refreshIndicatorKey.currentState?.show();
  }

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
    notifyListeners();
  }

  void setPersonalHome(bool isPersonalHome) {
    personalHome = isPersonalHome;
    notifyListeners();
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

  void setHideBusinessUserDetails(bool hideBusinessUserDetails) {
    this.hideBusinessUserDetails = hideBusinessUserDetails;
    notifyListeners();
  }

  void setUserProfilePicUrl(String url) {
    userProfilePicUrl = url;
    userProfilePicture =
        url.isNotEmpty ? CachedNetworkImageProvider(url) : null;
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
    businessProfilePicture =
        url.isNotEmpty ? CachedNetworkImageProvider(url) : null;
    notifyListeners();
  }

  void setBusinessUser({required BusinessUser newBusinessUser}) {
    businessUser = newBusinessUser;
    notifyListeners();
  }

  void setBusinessUserSignatureUrl(String url) {
    businessUserSignatureUrl = url;
    businessUserSignature =
        url.isNotEmpty ? CachedNetworkImageProvider(url) : null;
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

  void setUserearchResults({required List<AppUser> userSearchResults}) {
    this.userSearchResults = userSearchResults;
    notifyListeners();
  }

  void setPersonalLinks({required List<ProfileLink> personalLinks}) {
    this.personalLinks = personalLinks;
    notifyListeners();
  }

  void setBusinessLinks({required List<ProfileLink> businessLinks}) {
    this.businessLinks = businessLinks;
    notifyListeners();
  }

  void deleteProfileLink({required int linkId}) {
    personalLinks.removeWhere((link) => link.idprofile_links == linkId);
    businessLinks.removeWhere((link) => link.idprofile_links == linkId);
    notifyListeners();
  }

  void editProfileLink({required ProfileLink updatedLink}) {
    int personalIndex = personalLinks.indexWhere(
        (link) => link.idprofile_links == updatedLink.idprofile_links);
    int businessIndex = businessLinks.indexWhere(
        (link) => link.idprofile_links == updatedLink.idprofile_links);

    if (personalIndex != -1) {
      personalLinks[personalIndex] = updatedLink;
    }
    if (businessIndex != -1) {
      businessLinks[businessIndex] = updatedLink;
    }
    notifyListeners();
  }

  void reorderPersonalLinks({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ProfileLink link = personalLinks.removeAt(oldIndex);
    personalLinks.insert(newIndex, link);
    notifyListeners();
  }

  void reorderBusinessLinks({required int oldIndex, required int newIndex}) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final ProfileLink link = businessLinks.removeAt(oldIndex);
    businessLinks.insert(newIndex, link);
    notifyListeners();
  }
}
