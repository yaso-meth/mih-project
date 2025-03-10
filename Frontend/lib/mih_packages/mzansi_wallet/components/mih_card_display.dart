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
      case "best before":
        return Image.asset('images/loyalty_cards/best_before.png');
      case "checkers":
        return Image.asset('images/loyalty_cards/checkers.png');
      case "clicks":
        return Image.asset('images/loyalty_cards/Clicks_Club.png');
      case "cotton:on":
        return Image.asset('images/loyalty_cards/cotton_on_perks.png');
      case "dis-chem":
        return Image.asset('images/loyalty_cards/dischem_benefit.png');
      case "pick n pay":
        return Image.asset('images/loyalty_cards/pnp_smart.png');
      case "shoprite":
        return Image.asset('images/loyalty_cards/shoprite.png');
      case "spar":
        return Image.asset('images/loyalty_cards/spar_rewards.png');
      case "woolworths":
        return Image.asset('images/loyalty_cards/wrewards.png');
      case "makro":
        return Image.asset('images/loyalty_cards/makro.png');
      case "fresh stop":
        return Image.asset('images/loyalty_cards/fresh_stop.png');
      case "panarottis":
        return Image.asset('images/loyalty_cards/panarottis.png');
      case "shell":
        return Image.asset('images/loyalty_cards/Shell.png');
      case "edgars":
        return Image.asset('images/loyalty_cards/edgars.png');
      case "jet":
        return Image.asset('images/loyalty_cards/jet.png');
      case "spur":
        return Image.asset('images/loyalty_cards/spur.png');
      case "infinity":
        return Image.asset('images/loyalty_cards/infinity.png');
      case "eskom":
        return Image.asset('images/loyalty_cards/eskom.png');
      default:
        return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayLoyaltyCard();
  }
}
