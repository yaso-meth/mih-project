import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/claim_statement_file.dart';
import 'package:mzansi_innovation_hub/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_objects/notes.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_claim_statement_generation_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';

class PatientManagerHiveData {
  final Box<Patient?> _patientInfoBox = Hive.box<Patient?>('patient_info_box');
  final Box<List> _patientNoteBox = Hive.box<List>('patient_note_box');
  final Box<List> _patientFileBox = Hive.box<List>('patient_file_box');
  final Box<List> _patientClaimBox = Hive.box<List>('patient_claim_box');
  final Box<String> _patientProPicUrlBox =
      Hive.box<String>('patient_pro_pic_url_box');
  final Box<PatientAccess> _myPatientAccessListBox =
      Hive.box<PatientAccess>('my_patient_access_list_box');

  Future<void> clearPatientManagerCache() async {
    try {
      await _patientInfoBox.clear();
      await _patientNoteBox.clear();
      await _patientFileBox.clear();
      await _patientClaimBox.clear();
      await _patientProPicUrlBox.clear();
      await _myPatientAccessListBox.clear();
      KenLogger.success("Cleared Local Patient Manager Cache.");
    } catch (error) {
      KenLogger.error("Failed to clear local Patient Manager cache.");
    }
  }

  Patient? getCachedPatient(String appId) {
    return _patientInfoBox.get(appId);
  }

  String? getCachedPatientProPicUrl(String appId) {
    return _patientProPicUrlBox.get(appId);
  }

  List<Note> getCachedPatientNotes(String appId) {
    final list = _patientNoteBox.get(appId);
    if (list == null) return [];
    List<Note> sortedNotes = List<Note>.from(list);
    sortedNotes.sort((a, b) {
      final dateA = DateTime.parse(a.insert_date);
      final dateB = DateTime.parse(b.insert_date);
      return dateA.compareTo(dateB);
    });
    return sortedNotes;
  }

  List<ClaimStatementFile> getCachedPatientClaims(String appId) {
    final list = _patientClaimBox.get(appId);
    if (list == null) return [];
    List<ClaimStatementFile> sortedFiles = List<ClaimStatementFile>.from(list);
    // sortedFiles.sort((a, b) {
    //   String fileNameA = a.file_name;
    //   String fileNameB = b.file_name;
    //   return fileNameA.compareTo(fileNameB);
    // });
    return sortedFiles;
  }

  List<PFile> getCachedPatientFiles(String appId) {
    final list = _patientFileBox.get(appId);
    if (list == null) return [];
    List<PFile> sortedFiles = List<PFile>.from(list);
    // sortedFiles.sort((a, b) {
    //   String fileNameA = a.file_name;
    //   String fileNameB = b.file_name;
    //   return fileNameA.compareTo(fileNameB);
    // });
    return sortedFiles;
  }

  List<PatientAccess> getCachedPatientAccessList() {
    return _myPatientAccessListBox.values.toList();
  }

  Future<void> cachePatientData(String appId, Patient? remotePatient) async {
    await _patientInfoBox.put(appId, remotePatient);
    KenLogger.success("Patient Info Cached");
  }

  Future<void> cachePatientProPicUrlData(
      Patient remotePatient, String remoteProPicUrl) async {
    await _patientProPicUrlBox.put(remotePatient.app_id, remoteProPicUrl);
    KenLogger.success("Patient Profile Picture Cached");
  }

  Future<void> cachePatientNoteData(
    String appId,
    List<Note> remotePatientNotes,
  ) async {
    await _patientNoteBox.put(appId, remotePatientNotes);
    KenLogger.success("Patient Notes Cached");
  }

  Future<void> cachePatientFileData(
    String appId,
    List<PFile> remotePatientFiles,
  ) async {
    await _patientFileBox.put(appId, remotePatientFiles);
    KenLogger.success("Patient Files Cached");
  }

  Future<void> cachePatientClaimsData(
    String appId,
    List<ClaimStatementFile> remotePatientClaims,
  ) async {
    await _patientClaimBox.put(appId, remotePatientClaims);
    KenLogger.success("Patient Claims Cached");
  }

  Future<void> cachePatientAccessData(
      List<PatientAccess> remotePatientAccess) async {
    await _myPatientAccessListBox.clear();
    await _myPatientAccessListBox.addAll(remotePatientAccess);
    KenLogger.success("Patient Access List Cached");
  }

  Future<bool> syncPatientWithServer(String appId) async {
    try {
      final remotePatient =
          await MihPatientServices().getPatientDetailsV2(appId);
      if (remotePatient != null) {
        await cachePatientData(appId, remotePatient);
        final remotePatientUser = await MihUserServices().getMyUserDetailsV2();
        final remoteProPicUrl =
            MihFileApi.getMinioFileUrlV2(remotePatientUser!.pro_pic_path);
        await cachePatientProPicUrlData(remotePatient, remoteProPicUrl);
        final remotePatientNotes =
            await MihPatientServices().getPatientConsultationNotesV2(appId);
        await cachePatientNoteData(remotePatient.app_id, remotePatientNotes);
        final remotePatientFiles =
            await MihPatientServices().getPatientDocumentsV2(appId);
        await cachePatientFileData(remotePatient.app_id, remotePatientFiles);
        final remotePatientClaims = await MIHClaimStatementGenerationApi
            .getClaimStatementFilesByPatientV2(appId);
        await cachePatientClaimsData(remotePatient.app_id, remotePatientClaims);
        return true;
      } else {
        await cachePatientData(appId, remotePatient);
        // KenLogger.info(
        //     "Patient Manager: No patient details found on the server for appId: $appId.");
        return true;
      }
    } catch (error) {
      KenLogger.warning(
          "Patient Info: MIH App Operating in Offline Mode. Sync Paused.\n $error");
      return false;
    }
  }

  Future<bool> syncPatientManagerWithServer(String businessId) async {
    try {
      final remotePatientAccess = await MihPatientServices()
          .getPatientAccessListOfBusinessV2(businessId);
      await cachePatientAccessData(remotePatientAccess);
      return true;
    } catch (error) {
      KenLogger.warning(
          "Patient Info: MIH App Operating in Offline Mode. Sync Paused.\n $error");
      return false;
    }
  }
}
