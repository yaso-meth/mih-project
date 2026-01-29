import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';

class MihAccessControllsProvider extends ChangeNotifier {
  int toolIndex;
  List<PatientAccess>? accessList;

  MihAccessControllsProvider({
    this.toolIndex = 0,
  });

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
