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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/bb_club.png'),
            ),
          ],
        );
      case "checkers":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/xtraSavings.png'),
            ),
          ],
        );
      case "clicks":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/Clicks_Club.png'),
            ),
          ],
        );
      case "dis-chem":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/dischem_benefit.png'),
            ),
          ],
        );
      case "pick n pay":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/pnp_smart.png'),
            ),
          ],
        );
      case "spar":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/spar_rewards.png'),
            ),
          ],
        );
      case "woolworths":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: widget.height,
              child: Image.asset('images/loyalty_cards/wrewards.png'),
            ),
          ],
        );
      default:
        return const SizedBox(
          height: 150,
          //child: Placeholder(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayLoyaltyCard();
  }
}
