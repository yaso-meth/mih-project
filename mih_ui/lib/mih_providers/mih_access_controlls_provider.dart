import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/mih_access_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';

class MihAccessControllsProvider extends ChangeNotifier {
  final MihAccessHiveData _hiveDate;
  int toolIndex;
  List<PatientAccess>? accessList;

  MihAccessControllsProvider(
    this._hiveDate, {
    this.toolIndex = 0,
  });

  void loadCachedAccess() {
    accessList = _hiveDate.getCachedAccess();
    KenLogger.success("Access List Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData(
    MzansiProfileProvider profileProvider,
  ) async {
    bool success = await _hiveDate.syncAccessWithServer(profileProvider);
    loadCachedAccess();
    return success;
  }

  Future<void> clearAccessCacheAndProvider() async {
    await _hiveDate.clearAccessCache();
    reset();
  }

  void reset() {
    toolIndex = 0;
    accessList = null;
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
  }

  void setAccessList(List<PatientAccess> accesses) {
    accessList = accesses;
    notifyListeners();
  }

  void editAccessItem(PatientAccess updatedAccess) {
    if (accessList == null) return;
    int index = accessList!.indexWhere((access) =>
        access.app_id == updatedAccess.app_id &&
        access.business_id == updatedAccess.business_id);
    if (index != -1) {
      accessList![index] = updatedAccess;
      notifyListeners();
    }
  }
}
