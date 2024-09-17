import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHTile extends StatefulWidget {
  final String tileName;
  //final String tileDescription;
  final Widget tileIcon;
  final void Function() onTap;
  // final Widget tileIcon;
  final Color p;
  final Color s;

  const MIHTile({
    super.key,
    required this.onTap,
    required this.tileName,
    //required this.tileDescription,
    required this.tileIcon,
    required this.p,
    required this.s,
  });

  @override
  State<MIHTile> createState() => _MIHTileState();
}

class _MIHTileState extends State<MIHTile> {
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
    // print(
    //     "Tile Name: ${widget.tileName}\nTitle Type: ${widget.tileIcon.runtimeType.toString()}");
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: mainC,
            borderRadius: BorderRadius.circular(80),
            child: Ink(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: widget.onTap,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: widget.tileIcon,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.tileName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
