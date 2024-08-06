import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/businessUser.dart';

class BusinessUserScreenArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;

  BusinessUserScreenArguments(this.signedInUser, this.businessUser);
}
