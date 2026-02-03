import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/components/board_square.dart';

class MineTile extends StatelessWidget {
  final BoardSquare square;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const MineTile({
    super.key,
    required this.square,
    required this.onTap,
    required this.onLongPress,
  });

  Widget _getTileContent(BuildContext context) {
    if (square.isFlagged) {
      return Icon(
        Icons.flag,
        color: MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        ),
      );
    }

    if (square.isOpened) {
      if (square.hasBomb) {
        return const Icon(FontAwesomeIcons.bomb, color: Colors.black);
      } else if (square.bombsAround > 0) {
        // Display bomb count
        return Center(
          child: Text(
            '${square.bombsAround}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: _getTileColor(square.bombsAround, context),
            ),
          ),
        );
      } else {
        // Opened, but no bomb count (empty square)
        return const SizedBox.shrink();
      }
    }

    // Default: Unopened tile
    return const SizedBox.shrink();
  }

  Color _getTileColor(int bombsAround, BuildContext context) {
    // Choose colors based on standard Minesweeper appearance
    switch (bombsAround) {
      case 1:
        return MihColors.getBluishPurpleColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        );
      // return Colors.blue;
      case 2:
        return MihColors.getGreenColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        );
      // return Colors.green;
      case 3:
        return MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        );
      // return Colors.red;
      case 4:
        return MihColors.getPurpleColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        );
      // return Colors.purple;
      case 5:
        return MihColors.getOrangeColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark",
        );
      // return Colors.brown;
      default:
        // return MihColors.getBluishPurpleColor(
        //   MzansiInnovationHub.of(context)!.theme.mode == "Dark",
        // );
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: MihButton(
        onPressed: onTap,
        onLongPressed: onLongPress,
        buttonColor: square.isOpened
            ? MihColors.getGreyColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark",
              )
            : MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark",
              ),
        width: 50,
        height: 50,
        borderRadius: 3,
        child: _getTileContent(context),
      ),
    );
  }
}
