import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/businessUser.dart';

class BusinessUpdateArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;

  BusinessUpdateArguments(this.signedInUser, this.businessUser);
}

class PatientViewArguments {
  final AppUser signedInUser;
  final String type;

  PatientViewArguments(this.signedInUser, this.type);
}
