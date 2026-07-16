import 'package:hive_ce_flutter/adapters.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';

class AboutMihHiveData {
  final Box<int> _mihUserBusinessCountBox = Hive.box<int>('about_mih_box');

  static const String kUserCountKey = 'current_user_count';
  static const String kBusinessCountKey = 'current_business_count';

  // Clear Local Cache
  Future<void> clearAboutMIHCache() async {
    try {
      await _mihUserBusinessCountBox.clear();
      KenLogger.success("Cleared Local About MIH Cache.");
    } catch (error) {
      KenLogger.error("Failed to clear local about mih cache.");
    }
  }

  // Get Data from local storage
  int? getcachedUserCount() => _mihUserBusinessCountBox.get(kUserCountKey);
  int? getcachedBusinessCount() =>
      _mihUserBusinessCountBox.get(kBusinessCountKey);

  // Caching Data to local storage
  Future<void> cacheUserCount(int remoteUserCount) async {
    await _mihUserBusinessCountBox.put(kUserCountKey, remoteUserCount);
    KenLogger.success("MIH User Count Cached");
  }

  Future<void> cacheBusinessCount(int remoteBusinessCount) async {
    await _mihUserBusinessCountBox.put(kBusinessCountKey, remoteBusinessCount);
    KenLogger.success("MIH Business Count Cached");
  }

  // Sync Local Data from data from MIH Server
  Future<bool> syncAboutMihDataWithServer() async {
    try {
      int remoteUserCount = await MihUserServices().fetchUserCount();
      await cacheUserCount(remoteUserCount);
      int remoteBusinessCount =
          await MihBusinessDetailsServices().fetchBusinessCount();
      await cacheBusinessCount(remoteBusinessCount);
      return true;
    } catch (error) {
      KenLogger.warning(
          "About MIH: MIH App Operating in Offline Mode. Sync Paused");
      return false;
    }
  }
}
