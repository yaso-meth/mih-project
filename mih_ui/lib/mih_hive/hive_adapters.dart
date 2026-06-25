// hive_adapters.dart
import 'package:hive_ce/hive_ce.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';

@GenerateAdapters([
  AdapterSpec<AppUser>(),
  AdapterSpec<Business>(),
  AdapterSpec<BusinessUser>(),
  AdapterSpec<UserConsent>(),
  AdapterSpec<ProfileLink>(),
  AdapterSpec<BusinessEmployee>(),
])
part 'hive_adapters.g.dart';
