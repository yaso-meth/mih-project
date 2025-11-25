import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_consent_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';

class MihDataHelperServices {
  Future<void> getUserData(MzansiProfileProvider profileProvider) async {
    String url;
    await MihUserServices().getMyUserDetails(profileProvider);
    url = await MihFileApi.getMinioFileUrl(
      profileProvider.user!.pro_pic_path,
    );
    profileProvider.setUserProfilePicUrl(url);
  }

  Future<void> getUserConsentStatus(
      MzansiProfileProvider profileProvider) async {
    await MihUserConsentServices().getUserConsentStatus(profileProvider);
  }

  Future<void> getBusinessData(MzansiProfileProvider profileProvider) async {
    AppUser? user = profileProvider.user;
    String logoUrl;
    String signatureUrl;
    Business? responseBusiness = await MihBusinessDetailsServices()
        .getBusinessDetailsByUser(profileProvider);
    if (responseBusiness != null && user!.type == "business") {
      logoUrl = await MihFileApi.getMinioFileUrl(
        profileProvider.business!.logo_path,
      );
      profileProvider.setBusinessProfilePicUrl(logoUrl);
      await MihMyBusinessUserServices().getBusinessUser(profileProvider);
      signatureUrl = await MihFileApi.getMinioFileUrl(
        profileProvider.businessUser!.sig_path,
      );
      profileProvider.setBusinessUserSignatureUrl(signatureUrl);
    }
  }

  Future<void> loadUserDataOnly(MzansiProfileProvider profileProvider) async {
    if (profileProvider.user == null) {
      await getUserData(profileProvider);
    }
    if (profileProvider.userConsent == null) {
      await getUserConsentStatus(profileProvider);
    }
  }

  Future<void> loadUserDataWithBusinessesData(
      MzansiProfileProvider profileProvider) async {
    if (profileProvider.user == null) {
      await getUserData(profileProvider);
    }
    if (profileProvider.userConsent == null) {
      await getUserConsentStatus(profileProvider);
    }
    if (profileProvider.user != null &&
        profileProvider.user!.type == "business" &&
        profileProvider.business == null) {
      await getBusinessData(profileProvider);
    }
  }
}
