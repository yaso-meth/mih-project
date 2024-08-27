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

class FileViewArguments {
  final String link;
  final String path;

  FileViewArguments(
    this.link,
    this.path,
  );
}

class PatientViewArguments {
  final AppUser signedInUser;
  final Patient? selectedPatient;
  final BusinessUser? businessUser;
  final Business? business;
  final String type;

  PatientViewArguments(
    this.signedInUser,
    this.selectedPatient,
    this.businessUser,
    this.business,
    this.type,
  );
}

class PatientEditArguments {
  final AppUser signedInUser;
  final Patient selectedPatient;

  PatientEditArguments(
    this.signedInUser,
    this.selectedPatient,
  );
}
