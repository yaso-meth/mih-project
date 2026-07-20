import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart'
    if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_go_router.dart';
import 'package:mzansi_innovation_hub/mih_hive/hive_registrar.g.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';
import 'mih_config/mih_env.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppEnviroment.setupEnv(Enviroment.dev);
  SuperTokens.init(
    apiDomain: AppEnviroment.baseApiUrl,
    apiBasePath: "/auth",
  );
  // Offine Hive Data
  await Hive.initFlutter('mih_offline_storage');
  Hive.registerAdapters();
  // Mzansi Profile Data
  await Hive.openBox<AppUser>('user_box');
  await Hive.openBox<Business>('business_box');
  await Hive.openBox<BusinessUser>('business_user_box');
  await Hive.openBox<UserConsent>('user_consent_box');
  await Hive.openBox<ProfileLink>('personal_profile_links_box');
  await Hive.openBox<ProfileLink>('business_profile_links_box');
  await Hive.openBox<BusinessEmployee>('business_employees_box');
  await Hive.openBox<Map>('profile_modifications_queue');
  // Mzansi Wallet Data
  await Hive.openBox<MIHLoyaltyCard>('loyalty_card_box');
  await Hive.openBox<MIHLoyaltyCard>('fav_loyalty_card_box');
  await Hive.openBox<Map>('wallet_modifications_queue');
  // About MIH Data
  await Hive.openBox<int>('about_mih_box');
  // Mih Calendar Data
  await Hive.openBox<List>('personal_calendar_box');
  await Hive.openBox<List>('business_calendar_box');
  await Hive.openBox<Map>('calendar_modifications_queue');
  // Mzansi Directory Data
  await Hive.openBox<BookmarkedBusiness>('bookmarked_business_box');
  await Hive.openBox<Business>('favourite_business_box');
  await Hive.openBox<String>('business_types_box');
  // Minesweeper Data
  await Hive.openBox<List>('ms_player_leaderboard_box');
  await Hive.openBox<List>('ms_my_leaderboard_box');
  await Hive.openBox<Map>('minesweeper_modifications_queue');
  //Patient Manager Data
  await Hive.openBox<Patient>('patient_info_box');
  await Hive.openBox<List>('patient_note_box');
  await Hive.openBox<List>('patient_file_box');
  await Hive.openBox<List>('patient_claim_box');
  await Hive.openBox<String>('patient_pro_pic_url_box');
  await Hive.openBox<PatientAccess>('my_patient_access_list_box');

  // await Firebase.initializeApp(
  //   // options: DefaultFirebaseOptions.currentPlatform,
  //   options: (Platform.isLinux)
  //       ? DefaultFirebaseOptions.web // Forces Linux to use the Web config
  //       : DefaultFirebaseOptions.currentPlatform,
  // );
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    const List<String> testDeviceIds = ['733d4c68-9b54-453a-9622-2df407310f40'];
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: testDeviceIds,
      ),
    );
    MobileAds.instance.initialize();
  } else {
    usePathUrlStrategy();
  }
  final GoRouter appRouter = MihGoRouter().mihRouter;
  runApp(MzansiInnovationHub(
    router: appRouter,
  ));
}
