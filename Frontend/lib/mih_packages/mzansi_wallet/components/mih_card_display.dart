import 'package:Mzansi_Innovation_Hub/main.dart';
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
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/bb_club.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Best Before",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "checkers":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/checkers_xtra.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Checkers",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "clicks":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/Clicks_Club.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Clicks",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "cotton:on":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child:
                      Image.asset('images/loyalty_cards/cotton_on_perks.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Cotton:On",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "dis-chem":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child:
                      Image.asset('images/loyalty_cards/dischem_benefit.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Dis-Chem",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "pick n pay":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/pnp_smart.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Pick 'n Pay",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "shoprite":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/shoprite_xtra.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Shoprite",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "spar":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/spar_rewards.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Spar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      case "woolworths":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: widget.height,
                  child: Image.asset('images/loyalty_cards/wrewards.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "WoolWorths",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox(
          height: 150,
          child: Placeholder(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayLoyaltyCard();
  }
}
