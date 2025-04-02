import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_profile_picture.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/notification.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/patients.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mih_home/package_tools/mih_business_home.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mih_home/package_tools/mih_personal_home.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MihHome extends StatefulWidget {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;
  final Patient? patient;
  final List<MIHNotification> notifications;
  final ImageProvider<Object>? propicFile;
  final bool isUserNew;
  final bool isBusinessUser;
  final bool isBusinessUserNew;
  final bool isDevActive;
  bool personalSelected;
  MihHome({
    super.key,
    required this.signedInUser,
    required this.businessUser,
    required this.business,
    required this.patient,
    required this.notifications,
    required this.propicFile,
    required this.isUserNew,
    required this.isBusinessUser,
    required this.isBusinessUserNew,
    required this.isDevActive,
    required this.personalSelected,
  });

  @override
  State<MihHome> createState() => _MihHomeState();
}

class _MihHomeState extends State<MihHome> {
  final proPicController = TextEditingController();
  late int _selcetedIndex;
  late bool _personalSelected;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.personalSelected == true) {
      setState(() {
        _selcetedIndex = 0;
        _personalSelected = true;
      });
    } else {
      setState(() {
        _selcetedIndex = 1;
        _personalSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MihApp(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      actionDrawer: getActionDrawer(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        if (_selcetedIndex == 0) {
          setState(() {
            _selcetedIndex = newValue;
            _personalSelected = true;
          });
        } else {
          setState(() {
            _selcetedIndex = newValue;
            _personalSelected = false;
          });
        }
      },
    );
  }

  Widget getAction() {
    return Builder(builder: (context) {
      return MihAppAction(
        icon: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: MIHProfilePicture(
            profilePictureFile: widget.propicFile,
            proPicController: proPicController,
            proPic: null,
            width: 45,
            radius: 21,
            drawerMode: false,
            editable: false,
            onChange: (newProPic) {},
          ),
        ),
        iconSize: 45,
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
      );
    });
  }

  MIHAppDrawer getActionDrawer() {
    return MIHAppDrawer(
      signedInUser: widget.signedInUser,
      propicFile: widget.propicFile,
    );
  }

  MihAppTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      setState(() {
        _selcetedIndex = 0;
        _personalSelected = true;
      });
    };
    if (widget.isBusinessUser) {
      temp[const Icon(Icons.business_center)] = () {
        setState(() {
          _selcetedIndex = 1;
          _personalSelected = false;
        });
      };
    }
    return MihAppTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [];
    toolBodies.add(
      MihPersonalHome(
        signedInUser: widget.signedInUser,
        personalSelected: _personalSelected,
        business: widget.business,
        businessUser: widget.businessUser,
        propicFile: widget.propicFile,
        isUserNew: widget.isUserNew,
      ),
    );
    if (widget.isBusinessUser) {
      toolBodies.add(
        MihBusinessHome(
          signedInUser: widget.signedInUser,
          personalSelected: _personalSelected,
          businessUser: widget.businessUser,
          business: widget.business,
          isBusinessUserNew: widget.isBusinessUserNew,
        ),
      );
    }
    return toolBodies;
  }
}
