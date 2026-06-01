import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihCardDisplay extends StatefulWidget {
  final String shopName;
  final String nickname;
  const MihCardDisplay({
    super.key,
    required this.shopName,
    required this.nickname,
  });

  @override
  State<MihCardDisplay> createState() => _MihCardDisplayState();
}

class _MihCardDisplayState extends State<MihCardDisplay> {
  Widget? displayLoyaltyCard() {
    switch (widget.shopName.toLowerCase()) {
      case "apple tree":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/apple_tree.png');
      case "best before":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/best_before.png');
      case "checkers":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/checkers.png');
      case "clicks":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/clicks.png');
      case "cotton:on":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/cotton_on.png');
      case "dis-chem":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/dischem.png');
      case "pick n pay":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/pick_n_pay.png');
      case "shoprite":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/shoprite.png');
      case "spar":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/spar.png');
      case "woolworths":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/woolworths.png');
      case "makro":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/makro.png');
      case "fresh stop":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/fresh_stop.png');
      case "panarottis":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/panarottis.png');
      case "shell":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/shell.png');
      case "edgars":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/edgars.png');
      case "jet":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/jet.png');
      case "spur":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/spur.png');
      case "infinity":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/infinity.png');
      case "eskom":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/eskom.png');
      case "+more":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/plus_more.png');
      case "bp":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/bp.png');
      case "builders warehouse":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/builders.png');
      case "exclusive books":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/exclusive_books.png');
      case "pna":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/pna.png');
      case "pq clothing":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/pq.png');
      case "rage":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/rage.png');
      case "sasol":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/sasol.png');
      case "tfg group":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/tfg.png');
      case "toys r us":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/toys_r_us.png');
      case "leroy merlin":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/leroy_merlin.png');
      case "signature cosmetics & fragrances":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/signature.png');
      case "ok foods":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/ok_foods.png');
      case "choppies":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/choppies.png');
      case "boxer":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/boxer.png');
      case "carrefour":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/carrefour.png');
      case "sefalana":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/sefalana.png');
      case "big save":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/big_save.png');
      case "justrite":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/justrite.png');
      case "naivas":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/naivas.png');
      case "kero":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/kero.png');
      case "auchan":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/auchan.png');
      case "woermann brock":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/woermann_brock.png');
      case "continente":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/continente.png');
      case "fresmart":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/fresmart.png');
      case "total energies":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/total.png');
      case "engen":
        return Image.asset(
            'lib/mih_package_components/assets/images/loyalty_cards/engen.png');
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: displayLoyaltyCard() != null,
      child: Stack(
        children: [
          if (displayLoyaltyCard() != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: displayLoyaltyCard()!,
            ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.nickname.isNotEmpty ? 8.0 : 0.0),
                decoration: BoxDecoration(
                  color: MihColors.primary(),
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Text(
                  widget.nickname,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
