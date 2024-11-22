class MIHLoyaltyCard {
  final int idloyalty_cards;
  final String app_id;
  final String shop_name;
  final String card_number;

  const MIHLoyaltyCard({
    required this.idloyalty_cards,
    required this.app_id,
    required this.shop_name,
    required this.card_number,
  });

  factory MIHLoyaltyCard.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idloyalty_cards": int idloyalty_cards,
        "app_id": String app_id,
        "shop_name": String shop_name,
        "card_number": String card_number,
      } =>
        MIHLoyaltyCard(
          idloyalty_cards: idloyalty_cards,
          app_id: app_id,
          shop_name: shop_name,
          card_number: card_number,
        ),
      _ => throw const FormatException('Failed to load loyalty card.'),
    };
  }
}
