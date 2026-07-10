import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';

class MzansiDirectoryHiveData {
  final Box<BookmarkedBusiness> _bookmarkedBusinessBox =
      Hive.box<BookmarkedBusiness>('bookmarked_business_box');
  final Box<Business> _favouriteBusinessBox =
      Hive.box<Business>('favourite_business_box');

  Future<void> clearDirectoryCache() async {
    try {
      _bookmarkedBusinessBox.clear();
      _favouriteBusinessBox.clear();
      KenLogger.success("Cleared Local Directory Cache.");
    } catch (e) {
      KenLogger.success("Failed to Clear Local Directory Cache.");
    }
  }

  List<BookmarkedBusiness> getBookmarkedBusinesses() {
    return _bookmarkedBusinessBox.values.toList();
  }

  List<Business> getFavouriteBusinesses() {
    return _favouriteBusinessBox.values.toList();
  }

  Future<void> cacheBookmarkedBusinesses(
      List<BookmarkedBusiness> remoteBookmarkedBusinesses) async {
    KenLogger.info("Cache Bookmark 1");
    await _bookmarkedBusinessBox.clear();
    KenLogger.info("Cache Bookmark 2");
    await _bookmarkedBusinessBox.addAll(remoteBookmarkedBusinesses);
    KenLogger.success("Bookmarked Businesses Cached");
  }

  Future<void> cacheFavouriteBusinesses(
      List<Business> remoteFavouriteBusinesses) async {
    await _favouriteBusinessBox.clear();
    await _favouriteBusinessBox.addAll(remoteFavouriteBusinesses);
    KenLogger.success("Favourite Businesses Cached");
  }

  Future<bool> syncDirectoryDataWithServer(
      MzansiProfileProvider profileProvider) async {
    try {
      KenLogger.info("Sync 1");
      List<BookmarkedBusiness> remoteBookmarkedBusinesses =
          await MihMzansiDirectoryServices()
              .getAllUserBookmarkedBusinessV2(profileProvider.user!.app_id);
      KenLogger.info("Sync 2");
      await cacheBookmarkedBusinesses(remoteBookmarkedBusinesses);
      KenLogger.info("Sync 3");
      List<Business> remoteFavouriteBusinesses = [];
      for (var bus in _bookmarkedBusinessBox.values.toList()) {
        await MihBusinessDetailsServices()
            .getBusinessDetailsByBusinessId(bus.business_id)
            .then((business) async {
          remoteFavouriteBusinesses.add(business!);
        });
      }
      KenLogger.info("Sync 4");
      await cacheFavouriteBusinesses(remoteFavouriteBusinesses);
      return true;
    } catch (error) {
      KenLogger.warning(
          "Directory: MIH App Operating in Offline Mode. Sync Paused $error");
      return false;
    }
  }
}
