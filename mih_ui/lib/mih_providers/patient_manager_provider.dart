import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/patient_manager_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/claim_statement_file.dart';
import 'package:mzansi_innovation_hub/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_objects/notes.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';

class PatientManagerProvider extends ChangeNotifier {
  final PatientManagerHiveData _hiveData;
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

  PatientManagerProvider(
    this._hiveData, {
    this.patientProfileIndex = 0,
    this.patientManagerIndex = 0,
    this.fileViewerIndex = 0,
    this.personalMode = true,
    this.hidePatientDetails = true,
  });

  void loadCachedPatientManager(String appId) {
    selectedPatient = _hiveData.getCachedPatient(appId);
    consultationNotes = _hiveData.getCachedPatientNotes(appId);
    patientDocuments = _hiveData.getCachedPatientFiles(appId);
    patientClaimsDocuments = _hiveData.getCachedPatientClaims(appId);
    selectedPatientProfilePictureUrl =
        _hiveData.getCachedPatientProPicUrl(appId) ?? "";
    selectedPatientProfilePicture = selectedPatientProfilePictureUrl!.isNotEmpty
        ? CachedNetworkImageProvider(selectedPatientProfilePictureUrl!)
        : null;
    myPaitentList = _hiveData.getCachedPatientAccessList();
    KenLogger.success("Patient Manager Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData(String? appId, String? businessId) async {
    bool success = false;
    if (appId != null) {
      success = await _hiveData.syncPatientWithServer(appId);
    }
    if (businessId != null) {
      success = await _hiveData.syncPatientManagerWithServer(businessId);
    }
    loadCachedPatientManager(appId ?? '');
    return success;
  }

  Future<void> clearPatientManagerCacheAndProvider() async {
    await _hiveData.clearPatientManagerCache();
    reset();
  }

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
