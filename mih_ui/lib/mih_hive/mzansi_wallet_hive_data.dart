import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';

class MzansiWalletHiveData {
  final Box<MIHLoyaltyCard> _loyaltyCardBox =
      Hive.box<MIHLoyaltyCard>('loyalty_card_box');
  final Box<MIHLoyaltyCard> _favLoyaltyCardBox =
      Hive.box<MIHLoyaltyCard>('fav_loyalty_card_box');

  // Get Offline Data
  List<MIHLoyaltyCard> getCachedLoyaltyCards() {
    final cards = _loyaltyCardBox.values.toList();
    cards.sort((a, b) => a.shop_name.compareTo(b.shop_name));
    return cards;
  }

  List<MIHLoyaltyCard> getCachedFavLoyaltyCards() {
    final cards = _favLoyaltyCardBox.values.toList();
    cards.sort((a, b) => a.shop_name.compareTo(b.shop_name));
    return cards;
  }

  // Cache data for offline use
  Future<void> cacheFavLoyaltyCardsData(
      List<MIHLoyaltyCard> remoteLoyaltyCards) async {
    await _favLoyaltyCardBox.clear();
    await _favLoyaltyCardBox.addAll(remoteLoyaltyCards);
    KenLogger.success("Favourite Loyalty Cards Cached");
  }

  Future<void> cacheLoyaltyCardsData(
      List<MIHLoyaltyCard> remoteFavLoyaltyCards) async {
    await _loyaltyCardBox.clear();
    await _loyaltyCardBox.addAll(remoteFavLoyaltyCards);
    KenLogger.success("Loyalty Cards Cached");
  }

  // Sync Local Data from data from MIH Server
  Future<bool> syncWalletWithServer(
      MzansiProfileProvider profileProvider) async {
    try {
      final remoteLoyaltyCards = await MIHMzansiWalletApis.getLoyaltyCardsV2(
          profileProvider.user!.app_id);
      cacheLoyaltyCardsData(remoteLoyaltyCards);
      final remoteFavLoyaltyCards =
          await MIHMzansiWalletApis.getFavouriteLoyaltyCardsV2(
              profileProvider.user!.app_id);
      cacheFavLoyaltyCardsData(remoteFavLoyaltyCards);
      return true;
    } catch (error) {
      KenLogger.warning("MIH App Operating in Offline Mode. Sync Paused");
      return false;
      // KenLogger.warning("App operating offline mode. Sync paused: $error");
    }
  }
}
