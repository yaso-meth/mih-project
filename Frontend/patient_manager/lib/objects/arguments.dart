import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';

class BusinessUpdateArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;

  BusinessUpdateArguments(
    this.signedInUser,
    this.businessUser,
    this.business,
  );
}

class PatientViewArguments {
  final AppUser signedInUser;
  final String type;

  PatientViewArguments(
    this.signedInUser,
    this.type,
  );
}
