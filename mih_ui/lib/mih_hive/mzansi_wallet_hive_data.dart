import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:uuid/uuid.dart';

class MzansiWalletHiveData {
  final Box<MIHLoyaltyCard> _loyaltyCardBox =
      Hive.box<MIHLoyaltyCard>('loyalty_card_box');
  final Box<MIHLoyaltyCard> _favLoyaltyCardBox =
      Hive.box<MIHLoyaltyCard>('fav_loyalty_card_box');
  final Box<Map> _modificationsQueue =
      Hive.box<Map>('wallet_modifications_queue');

  // Set offline data
  Future<void> clearWalletCache() async {
    try {
      await _loyaltyCardBox.clear();
      await _favLoyaltyCardBox.clear();
      await _modificationsQueue.clear();
      KenLogger.success("Cleared Local Wallet Cache.");
    } catch (error) {
      KenLogger.error("Failed to clear local wallet cache.");
    }
  }

  // Get Offline Data
  List<MIHLoyaltyCard> getCachedLoyaltyCards() {
    final cards = _loyaltyCardBox.values.toList();
    cards.sort((a, b) => a.shop_name.compareTo(b.shop_name));
    return cards;
  }

  List<MIHLoyaltyCard> getCachedFavLoyaltyCards() {
    final cards = _favLoyaltyCardBox.values.toList();
    cards.sort((a, b) => a.priority_index.compareTo(b.priority_index));
    return cards;
  }

  // Set Offline Data
  Future<void> addLoyaltyCardLocally(MIHLoyaltyCard newCard) async {
    await _loyaltyCardBox.put(newCard.offline_id, newCard);

    if (newCard.favourite == "Yes") {
      await _favLoyaltyCardBox.put(newCard.offline_id, newCard);
    }
    KenLogger.success("New Card Saved Locally.");
  }

  Future<void> deleteLoyaltyCardLocally(MIHLoyaltyCard deleteCard) async {
    dynamic mainTargetKey;
    dynamic favTargetKey;
    for (var key in _loyaltyCardBox.keys) {
      final card = _loyaltyCardBox.get(key);
      if (card != null) {
        if (deleteCard.idloyalty_cards != 0 &&
            card.idloyalty_cards == deleteCard.idloyalty_cards) {
          mainTargetKey = key;
          break;
        } else if (deleteCard.idloyalty_cards == 0 &&
            card.offline_id == deleteCard.offline_id) {
          mainTargetKey = key;
          break;
        }
      }
    }
    for (var key in _favLoyaltyCardBox.keys) {
      final card = _favLoyaltyCardBox.get(key);
      if (card != null) {
        if (deleteCard.idloyalty_cards != 0 &&
            card.idloyalty_cards == deleteCard.idloyalty_cards) {
          favTargetKey = key;
          break;
        } else if (deleteCard.idloyalty_cards == 0 &&
            card.offline_id == deleteCard.offline_id) {
          favTargetKey = key;
          break;
        }
      }
    }
    if (mainTargetKey != null) {
      await _loyaltyCardBox.delete(mainTargetKey);
      KenLogger.success("Card Deleted Locally.");
    }
    if (favTargetKey != null) {
      await _favLoyaltyCardBox.delete(favTargetKey);
      KenLogger.success("Fav Card Deleted Locally.");
    }
  }

  Future<void> updateLoyaltyCardLocally(MIHLoyaltyCard updatedCard) async {
    dynamic mainTargetKey;
    dynamic favTargetKey;
    for (var key in _loyaltyCardBox.keys) {
      final card = _loyaltyCardBox.get(key);
      if (card != null) {
        if (updatedCard.idloyalty_cards != 0 &&
            card.idloyalty_cards == updatedCard.idloyalty_cards) {
          mainTargetKey = key;
          break;
        } else if (updatedCard.idloyalty_cards == 0 &&
            card.offline_id == updatedCard.offline_id) {
          mainTargetKey = key;
          break;
        }
      }
    }
    for (var key in _favLoyaltyCardBox.keys) {
      final card = _favLoyaltyCardBox.get(key);
      if (card != null) {
        if (updatedCard.idloyalty_cards != 0 &&
            card.idloyalty_cards == updatedCard.idloyalty_cards) {
          favTargetKey = key;
          break;
        } else if (updatedCard.idloyalty_cards == 0 &&
            card.offline_id == updatedCard.offline_id) {
          favTargetKey = key;
          break;
        }
      }
    }
    if (mainTargetKey != null) {
      await _loyaltyCardBox.put(mainTargetKey, updatedCard);
      KenLogger.success("Card Udpdated Locally.");
    }
    if (favTargetKey != null) {
      if (updatedCard.favourite == "Yes") {
        await _favLoyaltyCardBox.put(favTargetKey, updatedCard);
        KenLogger.success("Fav Card Updated Locally.");
      } else {
        await _favLoyaltyCardBox.delete(favTargetKey);
        KenLogger.success("Fav Card Removed Locally.");
      }
    } else {
      if (updatedCard.offline_id == null) {
        final String uniqueKey = const Uuid().v4();
        await _favLoyaltyCardBox.put(uniqueKey, updatedCard);
        KenLogger.success("Fav Card Added Locally.");
      } else {
        await _favLoyaltyCardBox.put(updatedCard.offline_id, updatedCard);
        KenLogger.success("Fav Card Added Locally.");
      }
    }
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
      await cacheLoyaltyCardsData(remoteLoyaltyCards);
      final remoteFavLoyaltyCards =
          await MIHMzansiWalletApis.getFavouriteLoyaltyCardsV2(
              profileProvider.user!.app_id);
      await cacheFavLoyaltyCardsData(remoteFavLoyaltyCards);
      return true;
    } catch (error) {
      KenLogger.warning(
          "Mzansi Wallet: MIH App Operating in Offline Mode. Sync Paused.");
      return false;
    }
  }

  // Modicfications processing
  Future<void> queueAddModification(MIHLoyaltyCard newCardData) async {
    await _modificationsQueue.add({
      'action': 'ADD',
      'payload': newCardData,
    });
    KenLogger.warning("Add Card Queued For Online Sync");
  }

  Future<void> queueDeleteModification(MIHLoyaltyCard deleteCardData) async {
    await _modificationsQueue.add({
      'action': 'DELETE',
      'payload': deleteCardData,
    });
    KenLogger.warning("Delete Card Queued For Online Sync");
  }

  Future<void> queueUpdateModification(MIHLoyaltyCard updatedCardData) async {
    await _modificationsQueue.add({
      'action': 'UPDATE',
      'payload': updatedCardData,
    });
    KenLogger.warning("Update Card Queued For Online Sync");
  }

  Future<bool> processModificationsQueue() async {
    if (_modificationsQueue.isEmpty) {
      return true;
    }
    final List<dynamic> queueKeys = _modificationsQueue.keys.toList();
    for (var taskKey in queueKeys) {
      final task = _modificationsQueue.get(taskKey);
      if (task == null) {
        continue;
      }
      final String action = task['action'];
      final MIHLoyaltyCard taskCard = task['payload'];
      if (action == 'ADD') {
        dynamic deleteCardTaskKey;
        for (var entry in _modificationsQueue.toMap().entries) {
          if (entry.value['action'] == 'DELETE' &&
              entry.value['payload'].offline_id == taskCard.offline_id) {
            deleteCardTaskKey = entry.key;
            break;
          }
        }

        if (deleteCardTaskKey != null) {
          await _modificationsQueue.delete(taskKey); // Remove 'ADD'
          await _modificationsQueue
              .delete(deleteCardTaskKey); // Remove 'DELETE'
          KenLogger.success(
              "Offline card add & delete cancelled out. Queue cleaned.");
          continue;
        }

        final responseCode =
            await MIHMzansiWalletApis.addLoyaltyCardAPICallV2(taskCard);
        if (responseCode != null && responseCode == 201) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Add New Local Card to MIH Cloud");
        } else {
          KenLogger.warning(
              "Mzansi Wallet: MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
      if (action == 'DELETE') {
        final responseCode =
            await MIHMzansiWalletApis.deleteLoyaltyCardAPICallV2(taskCard);
        if (responseCode != null && responseCode == 200) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Delete Local Card from MIH Cloud");
        } else {
          KenLogger.warning(
              "Mzansi Wallet: MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
      if (action == 'UPDATE') {
        final responseCode =
            await MIHMzansiWalletApis.updateLoyaltyCardAPICallV2(taskCard);
        if (responseCode != null && responseCode == 200) {
          await _modificationsQueue.delete(taskKey);
          KenLogger.success("Update Local Card from MIH Cloud");
        } else {
          KenLogger.warning(
              "Mzansi Wallet: MIH App Operating in Offline Mode. Sync Paused");
          return false;
        }
      }
    }
    return true;
  }

  bool isModificationNotEmpty() {
    return _modificationsQueue.values.toList().isNotEmpty;
  }
}
