import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';

class MzansiWalletProvider extends ChangeNotifier {
  List<MIHLoyaltyCard> loyaltyCards;
  List<MIHLoyaltyCard> favouriteCards;
  int toolIndex;

  MzansiWalletProvider({
    this.loyaltyCards = const [],
    this.favouriteCards = const [],
    this.toolIndex = 0,
  });

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

  void addLoyaltyCard({required MIHLoyaltyCard newCard}) {
    loyaltyCards.add(newCard);
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
