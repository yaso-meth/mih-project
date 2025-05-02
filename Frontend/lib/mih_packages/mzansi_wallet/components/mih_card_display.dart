import 'package:flutter/material.dart';

class MihCardDisplay extends StatefulWidget {
  final String shopName;
  final double height;
  const MihCardDisplay({
    super.key,
    required this.shopName,
    required this.height,
  });

  @override
  State<MihCardDisplay> createState() => _MihCardDisplayState();
}

class _MihCardDisplayState extends State<MihCardDisplay> {
  Widget displayLoyaltyCard() {
    switch (widget.shopName.toLowerCase()) {
      case "apple tree":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/apple_tree-min.png');
      case "best before":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/best_before-min.png');
      case "checkers":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/checkers-min.png');
      case "clicks":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/clicks-min.png');
      case "cotton:on":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/cotton_on-min.png');
      case "dis-chem":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/dischem-min.png');
      case "pick n pay":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/pick_n_pay-min.png');
      case "shoprite":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/shoprite-min.png');
      case "spar":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/spar-min.png');
      case "woolworths":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/woolworths-min.png');
      case "makro":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/makro-min.png');
      case "fresh stop":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/fresh_stop-min.png');
      case "panarottis":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/panarottis-min.png');
      case "shell":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/shell-min.png');
      case "edgars":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/edgars-min.png');
      case "jet":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/jet-min.png');
      case "spur":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/spur-min.png');
      case "infinity":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/infinity-min.png');
      case "eskom":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/eskom-min.png');
      case "+more":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/plus_more-min.png');
      case "bp":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/bp-min.png');
      case "builders warehouse":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/builders-min.png');
      case "exclusive books":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/exclusive_books-min.png');
      case "pna":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/pna-min.png');
      case "pq clothing":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/pq-min.png');
      case "rage":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/rage-min.png');
      case "sasol":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/sasol-min.png');
      case "tfg group":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/tfg-min.png');
      case "toys r us":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/toysrus-min.png');
      case "leroy merlin":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/leroy_merlin-min.png');
      case "signature cosmetics & fragrances":
        return Image.asset(
            'lib/mih_components/mih_package_components/assets/images/loyalty_cards/mini/signature_cosmetics-min.png');
      default:
        return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayLoyaltyCard();
  }
}
