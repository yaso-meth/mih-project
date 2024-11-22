import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';

class LoyaltyCards extends StatefulWidget {
  final AppUser signedInUser;
  const LoyaltyCards({
    super.key,
    required this.signedInUser,
  });

  @override
  State<LoyaltyCards> createState() => _LoyaltyCardsState();
}

class _LoyaltyCardsState extends State<LoyaltyCards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Loyalty Cards",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_card),
              alignment: Alignment.topRight,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              onPressed: () {
                //
              },
            )
          ],
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        const SizedBox(height: 10),
      ],
    );
  }
}
