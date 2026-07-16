import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_hive/mzansi_wallet_hive_data.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';

class MzansiWalletProvider extends ChangeNotifier {
  final MzansiWalletHiveData _hiveData;

  List<MIHLoyaltyCard> loyaltyCards;
  List<MIHLoyaltyCard> favouriteCards;
  int toolIndex;

  MzansiWalletProvider(
    this._hiveData, {
    this.loyaltyCards = const [],
    this.favouriteCards = const [],
    this.toolIndex = 0,
  }) {
    loadCachedWallet();
  }

  void loadCachedWallet() {
    loyaltyCards = _hiveData.getCachedLoyaltyCards();
    favouriteCards = _hiveData.getCachedFavLoyaltyCards();

    KenLogger.success("Mzansi Wallet Loaded from Cache");
    notifyListeners();
  }

  Future<bool> syncWithMihServerData(
      MzansiProfileProvider profileProvider) async {
    await _hiveData.processModificationsQueue();
    bool success = await _hiveData.syncWalletWithServer(profileProvider);
    loadCachedWallet();
    return success;
  }

  Future<void> addLocalLoyaltyCard(
      MzansiProfileProvider profileProvider, MIHLoyaltyCard newCard) async {
    await _hiveData.addLoyaltyCardLocally(newCard);
    await _hiveData.queueAddModification(newCard);
    await _hiveData.processModificationsQueue();
    await _hiveData.syncWalletWithServer(profileProvider);
    loadCachedWallet();
  }

  Future<void> deleteLocalLoyaltyCard(
      MzansiProfileProvider profileProvider, MIHLoyaltyCard deleteCard) async {
    await _hiveData.deleteLoyaltyCardLocally(deleteCard);
    await _hiveData.queueDeleteModification(deleteCard);
    loadCachedWallet();
    _hiveData.processModificationsQueue();
  }

  bool isLocalModificationsPending() {
    return _hiveData.isModificationNotEmpty();
  }

  Future<void> updateLocalLoyaltyCard(
      MzansiProfileProvider profileProvider, MIHLoyaltyCard updatedCard) async {
    await _hiveData.updateLoyaltyCardLocally(updatedCard);
    await _hiveData.queueUpdateModification(updatedCard);
    await _hiveData.processModificationsQueue();
    await _hiveData.syncWalletWithServer(profileProvider);
    loadCachedWallet();
  }

  Future<void> clearWalletCacheAndProvider() async {
    await _hiveData.clearWalletCache();
    reset();
  }

  void reset() {
    toolIndex = 0;
    loyaltyCards = [];
    favouriteCards = [];
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setLoyaltyCards({required List<MIHLoyaltyCard> cards}) async {
    loyaltyCards = cards;
    notifyListeners();
  }

  void setFavouriteCards({required List<MIHLoyaltyCard> cards}) async {
    favouriteCards = cards;
    notifyListeners();
  }

  void deleteLoyaltyCard({required int cardId}) {
    loyaltyCards.removeWhere((card) => card.idloyalty_cards == cardId);
    notifyListeners();
  }

  void editLoyaltyCard({required MIHLoyaltyCard updatedCard}) {
    int index = loyaltyCards.indexWhere(
        (card) => card.idloyalty_cards == updatedCard.idloyalty_cards);
    if (index != -1) {
      loyaltyCards[index] = updatedCard;
      notifyListeners();
    }
  }
}
