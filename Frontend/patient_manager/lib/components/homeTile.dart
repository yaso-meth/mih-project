import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class HomeTile extends StatefulWidget {
  final String tileName;
  //final String tileDescription;
  final IconData tileIcon;
  final void Function() onTap;
  // final Widget tileIcon;
  final Color p;
  final Color s;

  const HomeTile({
    super.key,
    required this.onTap,
    required this.tileName,
    //required this.tileDescription,
    required this.tileIcon,
    required this.p,
    required this.s,
  });

  @override
  State<HomeTile> createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  late Color mainC;
  late Color secondC;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    mainC = widget.p;
    secondC = widget.s;
    super.initState();
  }

  // Widget displayTile() {
  //   return FittedBox(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         GestureDetector(
  //           onTap: widget.onTap,
  //           onTapDown: (_) {
  //             setState(() {
  //               mainC = MzanziInnovationHub.of(context)!.theme.primaryColor();
  //               secondC =
  //                   MzanziInnovationHub.of(context)!.theme.secondaryColor();
  //             });
  //           },
  //           onTapUp: (_) {
  //             setState(() {
  //               mainC = MzanziInnovationHub.of(context)!.theme.secondaryColor();
  //               secondC = MzanziInnovationHub.of(context)!.theme.primaryColor();
  //             });
  //           },
  //           child: Container(
  //             padding: const EdgeInsets.all(3.0),
  //             decoration: BoxDecoration(
  //               color: mainC,
  //               borderRadius: BorderRadius.circular(10.0),
  //               //border: Border.all(color: MzanziInnovationHub.of(context)!.theme.secondaryColor(), width: 1.0),
  //             ),
  //             child: Icon(
  //               widget.tileIcon,
  //               color: secondC,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 1),
  //         Row(
  //           children: [
  //             Flexible(
  //               child: Text(
  //                 widget.tileName,
  //                 textAlign: TextAlign.center,
  //                 softWrap: true,
  //                 overflow: TextOverflow.visible,
  //                 style: TextStyle(
  //                   color: mainC,
  //                   fontSize: 5.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FittedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              color: mainC,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(10),
                //highlightColor: secondC,
                child: Ink(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    widget.tileIcon,
                    color: secondC,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              widget.tileName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                fontSize: 5.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
