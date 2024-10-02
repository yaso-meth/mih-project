import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/business.dart';
import 'package:patient_manager/mih_objects/business_user.dart';
import 'package:patient_manager/mih_objects/patients.dart';

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

class HomeArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;
  final String profilePicUrl;

  HomeArguments(
    this.signedInUser,
    this.businessUser,
    this.business,
    this.profilePicUrl,
  );
}

class AppProfileUpdateArguments {
  final AppUser signedInUser;
  final ImageProvider<Object>? propicFile;

  AppProfileUpdateArguments(this.signedInUser, this.propicFile);
}

class FileViewArguments {
  final String link;
  final String path;

  FileViewArguments(
    this.link,
    this.path,
  );
}

class PrintPreviewArguments {
  final Uint8List pdfData;
  final String fileName;

  PrintPreviewArguments(
    this.pdfData,
    this.fileName,
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
