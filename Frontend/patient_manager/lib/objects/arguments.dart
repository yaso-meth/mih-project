import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/businessUser.dart';

class BusinessUpdateArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;

  BusinessUpdateArguments(this.signedInUser, this.businessUser);
}
