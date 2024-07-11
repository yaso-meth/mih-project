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
  void initState() {
    mainC = widget.p;
    secondC = widget.s;
    super.initState();
  }

  Widget displayTile() {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) {
              setState(() {
                mainC = MzanziInnovationHub.of(context)!.theme.primaryColor();
                secondC =
                    MzanziInnovationHub.of(context)!.theme.secondaryColor();
              });
            },
            onTapUp: (_) {
              setState(() {
                mainC = MzanziInnovationHub.of(context)!.theme.secondaryColor();
                secondC = MzanziInnovationHub.of(context)!.theme.primaryColor();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: mainC,
                borderRadius: BorderRadius.circular(10.0),
                //border: Border.all(color: MzanziInnovationHub.of(context)!.theme.secondaryColor(), width: 1.0),
              ),
              child: Icon(
                widget.tileIcon,
                color: secondC,
              ),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            widget.tileName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mainC,
              fontSize: 5.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) {
              setState(() {
                mainC = MzanziInnovationHub.of(context)!.theme.primaryColor();
                secondC =
                    MzanziInnovationHub.of(context)!.theme.secondaryColor();
              });
            },
            onTapUp: (_) {
              setState(() {
                mainC = MzanziInnovationHub.of(context)!.theme.secondaryColor();
                secondC = MzanziInnovationHub.of(context)!.theme.primaryColor();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: mainC,
                borderRadius: BorderRadius.circular(10.0),
                //border: Border.all(color: MzanziInnovationHub.of(context)!.theme.secondaryColor(), width: 1.0),
              ),
              child: Icon(
                widget.tileIcon,
                color: secondC,
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
    );
    // child: Card(
    //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
    //   elevation: 20,
    //   child: Column(
    //     //mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Expanded(
    //         child: ListTile(
    //             leading: Icon(
    //               widget.tileIcon,
    //               color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    //             ),
    //             title: Text(
    //               widget.tileName,
    //               style: TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    //               ),
    //             ),
    //             subtitle: Text(
    //               widget.tileDescription,
    //               style: TextStyle(color: MzanziInnovationHub.of(context)!.theme.primaryColor()),
    //             )),
    //       ),
    //       Expanded(
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 10),
    //               child: Icon(
    //                 Icons.arrow_forward,
    //                 color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // ),
  }
}
