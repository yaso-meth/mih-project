import 'package:flutter/foundation.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/about_mih_hive_data.dart';

class AboutMihProvider extends ChangeNotifier {
  final AboutMihHiveData _hiveData;

  int toolIndex;
  String version = "1.4.0";
  int? userCount;
  int? businessCount;

  AboutMihProvider(
    this._hiveData, {
    this.toolIndex = 0,
  });

  void loadCachedAboutMihSate() {
    userCount = _hiveData.getcachedUserCount();
    businessCount = _hiveData.getcachedBusinessCount();

    KenLogger.success("About Mih Data Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData() async {
    bool success = await _hiveData.syncAboutMihDataWithServer();
    loadCachedAboutMihSate();
    return success;
  }

  void reset() {
    toolIndex = 0;
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }
}
