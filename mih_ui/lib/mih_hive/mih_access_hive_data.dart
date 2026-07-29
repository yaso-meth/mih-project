import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_access_controls_services.dart';

class MihAccessHiveData {
  final Box<PatientAccess> _patientAccessBox =
      Hive.box<PatientAccess>('patient_access_box');

  Future<void> clearAccessCache() async {
    try {
      await _patientAccessBox.clear();
      KenLogger.success("Cleared Local Access Cache.");
    } catch (error) {
      KenLogger.error("Failed to clear local access cache.");
    }
  }

  List<PatientAccess> getCachedAccess() {
    final accessList = _patientAccessBox.values.toList();
    accessList.sort((a, b) => a.business_name.compareTo(b.business_name));
    return accessList;
  }

  Future<void> cacheAccessData(List<PatientAccess> remoteAccessList) async {
    await _patientAccessBox.clear();
    await _patientAccessBox.addAll(remoteAccessList);
    KenLogger.success("Access List Cached");
  }

  Future<bool> syncAccessWithServer(
    MzansiProfileProvider profileProvider,
  ) async {
    try {
      final remoteAccessList = await MihAccessControlsServices()
          .getPatientAccessList(profileProvider.user!.app_id);
      await cacheAccessData(remoteAccessList);
      return true;
    } catch (error) {
      KenLogger.warning(
          "Access Controls: MIH App Operating in Offline Mode. Sync Paused.\n$error");
      return false;
    }
  }
}
