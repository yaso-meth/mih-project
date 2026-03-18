import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
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
        color: MihColors.red(),
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
        return MihColors.bluishPurple();
      // return Colors.blue;
      case 2:
        return MihColors.green();
      // return Colors.green;
      case 3:
        return MihColors.red();
      // return Colors.red;
      case 4:
        return MihColors.purple();
      // return Colors.purple;
      case 5:
        return MihColors.orange();
      // return Colors.brown;
      default:
        // return MihColors.bluishPurple(
        //   ,
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
        buttonColor: square.isOpened ? MihColors.grey() : MihColors.secondary(),
        width: 50,
        height: 50,
        borderRadius: 3,
        child: _getTileContent(context),
      ),
    );
  }
}
