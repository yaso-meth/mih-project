import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_consent_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';

class MzansiProfileHiveData {
  final Box<AppUser> _userBox = Hive.box<AppUser>('user_box');
  final Box<Business> _businessBox = Hive.box<Business>('business_box');
  final Box<BusinessUser> _businessUserBox =
      Hive.box<BusinessUser>('business_user_box');
  final Box<UserConsent> _userConsentBox =
      Hive.box<UserConsent>('user_consent_box');
  final Box<ProfileLink> _personalProfileLinksBox =
      Hive.box<ProfileLink>('personal_profile_links_box');

  final Box<String> _resolvedUrlsBox = Hive.box<String>('image_urls_box');

  static const String kUserKey = 'current_user';
  static const String kBusinessKey = 'current_business';
  static const String kBusinessUserKey = 'current_business_user';
  static const String kConsentKey = 'current_consent';
  static const String kUserPicUrlKey = 'user_pic_url';
  static const String kBusinessPicUrlKey = 'business_pic_url';
  static const String kSignatureUrlKey = 'signature_url';

  AppUser? getCachedUser() => _userBox.get(kUserKey);
  Business? getCachedBusiness() => _businessBox.get(kBusinessKey);
  BusinessUser? getCachedBusinessUser() =>
      _businessUserBox.get(kBusinessUserKey);
  UserConsent? getCachedConsent() => _userConsentBox.get(kConsentKey);
  String? getCachedUserPicUrl() => _resolvedUrlsBox.get(kUserPicUrlKey);
  String? getCachedBusinessPicUrl() => _resolvedUrlsBox.get(kBusinessPicUrlKey);
  String? getCachedSignatureUrl() => _resolvedUrlsBox.get(kSignatureUrlKey);
  List<ProfileLink> getCachedPersonalProfileLinks() {
    final links = _personalProfileLinksBox.values.toList();
    links.sort((a, b) => a.order.compareTo(b.order));
    return links;
  }

  Future<void> cacheUserData(AppUser remoteUser) async {
    await _userBox.put(kUserKey, remoteUser);
    if (remoteUser.pro_pic_path.isNotEmpty) {
      String userPicUrl =
          await MihFileApi.getMinioFileUrl(remoteUser.pro_pic_path);
      await _resolvedUrlsBox.put(kUserPicUrlKey, userPicUrl);
    }
  }

  Future<void> cacheUserConsentData(UserConsent remoteConsent) async {
    await _userConsentBox.put(kConsentKey, remoteConsent);
  }

  Future<void> cacheBusinessData(Business remoteBusiness) async {
    await _businessBox.put(kBusinessKey, remoteBusiness);
    if (remoteBusiness.logo_path.isNotEmpty) {
      String logoUrl =
          await MihFileApi.getMinioFileUrl(remoteBusiness.logo_path);
      await _resolvedUrlsBox.put(kBusinessPicUrlKey, logoUrl);
    }
    BusinessUser? remoteBizUser =
        await MihMyBusinessUserServices().getBusinessUserV2();
    if (remoteBizUser != null) {
      cacheBusinessUserData(remoteBizUser);
    }
  }

  Future<void> cacheBusinessUserData(BusinessUser remoteBizUser) async {
    await _businessUserBox.put(kBusinessUserKey, remoteBizUser);
    if (remoteBizUser.sig_path.isNotEmpty) {
      String signatureUrl =
          await MihFileApi.getMinioFileUrl(remoteBizUser.sig_path);
      await _resolvedUrlsBox.put(kSignatureUrlKey, signatureUrl);
    }
  }

  Future<void> cachePersonalProfileLinksData(
      List<ProfileLink> remoteLinks) async {
    await _personalProfileLinksBox.clear();
    await _personalProfileLinksBox.addAll(remoteLinks);
  }

  Future<void> syncProfileDataWithServer() async {
    try {
      AppUser? remoteUser = await MihUserServices().getMyUserDetailsV2();
      if (remoteUser != null) {
        cacheUserData(remoteUser);

        UserConsent? remoteConsent =
            await MihUserConsentServices().getUserConsentStatusV2();
        if (remoteConsent != null) {
          cacheUserConsentData(remoteConsent);
        }
        final remoteLinks = await MihProfileLinksServices.getUserProfileLinksV2(
            remoteUser.app_id);
        await cachePersonalProfileLinksData(remoteLinks);
      }
      Business? remoteBusiness =
          await MihBusinessDetailsServices().getBusinessDetailsByUserV2();
      if (remoteBusiness != null) {
        cacheBusinessData(remoteBusiness);
      }
    } catch (error) {
      KenLogger.warning("App operating offline mode. Sync paused");
      // KenLogger.warning("App operating offline mode. Sync paused: $error");
    }
  }
}
