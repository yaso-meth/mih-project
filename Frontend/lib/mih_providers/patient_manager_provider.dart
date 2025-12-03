import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_objects/claim_statement_file.dart';
import 'package:mzansi_innovation_hub/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_objects/notes.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';

class PatientManagerProvider extends ChangeNotifier {
  int patientProfileIndex;
  int patientManagerIndex;
  int fileViewerIndex;
  bool personalMode;
  List<PatientAccess>? myPaitentList;
  Patient? selectedPatient;
  String? selectedPatientProfilePictureUrl;
  ImageProvider<Object>? selectedPatientProfilePicture;
  bool hidePatientDetails;
  List<Note>? consultationNotes;
  List<PFile>? patientDocuments;
  List<ClaimStatementFile>? patientClaimsDocuments;
  List<Patient> patientSearchResults = [];

  PatientManagerProvider({
    this.patientProfileIndex = 0,
    this.patientManagerIndex = 0,
    this.fileViewerIndex = 0,
    this.personalMode = true,
    this.hidePatientDetails = true,
  });

  void reset() {
    patientProfileIndex = 0;
    patientManagerIndex = 0;
    personalMode = true;
    selectedPatient = null;
  }

  void setPatientProfileIndex(int index) {
    patientProfileIndex = index;
    notifyListeners();
  }

  void setPatientManagerIndex(int index) {
    patientManagerIndex = index;
    notifyListeners();
  }

  void setFileViewerIndex(int index) {
    patientProfileIndex = index;
    notifyListeners();
  }

  void setPersonalMode(bool personalMode) {
    this.personalMode = personalMode;
    notifyListeners();
  }

  void setSelectedPatient({required Patient? selectedPatient}) {
    this.selectedPatient = selectedPatient;
    notifyListeners();
  }

  void setSelectedPatientProfilePicUrl(String url) {
    selectedPatientProfilePictureUrl = url;
    selectedPatientProfilePicture =
        url.isNotEmpty ? CachedNetworkImageProvider(url) : null;
    notifyListeners();
  }

  void setHidePatientDetails(bool hidePatientDetails) {
    this.hidePatientDetails = hidePatientDetails;
    notifyListeners();
  }

  void setMyPatientList({required List<PatientAccess>? myPaitentList}) {
    this.myPaitentList = myPaitentList ?? [];
    notifyListeners();
  }

  void setConsultationNotes({required List<Note>? consultationNotes}) {
    this.consultationNotes = consultationNotes ?? [];
    notifyListeners();
  }

  void setPatientDocuments({required List<PFile>? patientDocuments}) {
    this.patientDocuments = patientDocuments ?? [];
    notifyListeners();
  }

  void setClaimsDocuments(
      {required List<ClaimStatementFile>? patientClaimsDocuments}) {
    this.patientClaimsDocuments = patientClaimsDocuments ?? [];
    notifyListeners();
  }

  void setPatientSearchResults({required List<Patient> patientSearchResults}) {
    this.patientSearchResults = patientSearchResults;
    notifyListeners();
  }
}
