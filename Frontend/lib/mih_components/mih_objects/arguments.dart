import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'app_user.dart';
import 'business.dart';
import 'business_user.dart';
import 'notification.dart';
import 'patients.dart';

class NotificationArguments {
  final String title;
  final String body;
  final void Function()? onTap;

  NotificationArguments(
    this.title,
    this.body,
    this.onTap,
  );
}

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

class BusinessViewArguments {
  final Business business;
  final String? startUpSearch;

  BusinessViewArguments(
    this.business,
    this.startUpSearch,
  );
}

class HomeArguments {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;
  final Patient? patient;
  final List<MIHNotification> notifi;
  final String profilePicUrl;

  HomeArguments(
    this.signedInUser,
    this.businessUser,
    this.business,
    this.patient,
    this.notifi,
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

class ClaimStatementGenerationArguments {
  final String document_type;
  final String patient_app_id;
  final String patient_full_name;
  final String patient_id_no;
  final String has_med_aid;
  final String med_aid_no;
  final String med_aid_code;
  final String med_aid_name;
  final String med_aid_scheme;
  final String busName;
  final String busAddr;
  final String busNo;
  final String busEmail;
  final String provider_name;
  final String practice_no;
  final String vat_no;
  final String service_date;
  final String service_desc;
  final String service_desc_option;
  final String procedure_name;
  final String procedure_additional_info;
  final String icd10_code;
  final String amount;
  final String pre_auth_no;
  final String logo_path;
  final String sig_path;

  ClaimStatementGenerationArguments(
    this.document_type,
    this.patient_app_id,
    this.patient_full_name,
    this.patient_id_no,
    this.has_med_aid,
    this.med_aid_no,
    this.med_aid_code,
    this.med_aid_name,
    this.med_aid_scheme,
    this.busName,
    this.busAddr,
    this.busNo,
    this.busEmail,
    this.provider_name,
    this.practice_no,
    this.vat_no,
    this.service_date,
    this.service_desc,
    this.service_desc_option,
    this.procedure_name,
    this.procedure_additional_info,
    this.icd10_code,
    this.amount,
    this.pre_auth_no,
    this.logo_path,
    this.sig_path,
  );
}

class AuthArguments {
  final bool personalSelected;
  final bool firstBoot;

  AuthArguments(
    this.personalSelected,
    this.firstBoot,
  );
}

class CalendarArguments {
  final AppUser signedInUser;
  final bool personalSelected;
  final Business? business;
  final BusinessUser? businessUser;

  CalendarArguments(
    this.signedInUser,
    this.personalSelected,
    this.business,
    this.businessUser,
  );
}

class PatManagerArguments {
  final AppUser signedInUser;
  final bool personalSelected;
  final Business? business;
  final BusinessUser? businessUser;

  PatManagerArguments(
    this.signedInUser,
    this.personalSelected,
    this.business,
    this.businessUser,
  );
}

class WalletArguments {
  final AppUser signedInUser;
  final int index;

  WalletArguments(
    this.signedInUser,
    this.index,
  );
}

class MzansiAiArguments {
  final AppUser signedInUser;
  final String? startUpQuestion;

  MzansiAiArguments(
    this.signedInUser,
    this.startUpQuestion,
  );
}

class MzansiDirectoryArguments {
  final String? startUpSearch;
  final bool personalSearch;

  MzansiDirectoryArguments(
    this.startUpSearch,
    this.personalSearch,
  );
}

class TestArguments {
  final AppUser user;
  final Business? business;

  TestArguments(
    this.user,
    this.business,
  );
}
