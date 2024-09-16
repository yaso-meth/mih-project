import 'package:flutter/material.dart';
import 'package:patient_manager/components/MIH_Layout/MIH_Action.dart';
import 'package:patient_manager/components/MIH_Layout/MIH_Body.dart';
import 'package:patient_manager/components/MIH_Layout/MIH_Header.dart';
import 'package:patient_manager/components/MIH_Layout/MIH_LayoutBuilder.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';

class MIHAbout extends StatefulWidget {
  const MIHAbout({
    super.key,
  });

  @override
  State<MIHAbout> createState() => _MIHAboutState();
}

class _MIHAboutState extends State<MIHAbout> {
  MIHAction getActionButton() {
    return MIHAction(
      icon: Icons.arrow_back,
      iconSize: 50,
      onTap: () {},
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "About",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHBody getBody() {
    return const MIHBody(
      borderOn: true,
      bodyItems: [
        Center(
          child: Mihloadingcircle(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      body: getBody(),
    );
  }
}
