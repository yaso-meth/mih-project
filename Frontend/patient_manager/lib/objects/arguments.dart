import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:patient_manager/objects/patients.dart';

class BusinessArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;

  BusinessArguments(
    this.signedInUser,
    this.businessUser,
    this.business,
  );
}

class PatientViewArguments {
  final AppUser signedInUser;
  final Patient? selectedPatient;
  final String type;

  PatientViewArguments(
    this.signedInUser,
    this.selectedPatient,
    this.type,
  );
}
