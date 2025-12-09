import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_zero.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_one.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_two.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:provider/provider.dart';

class PackageTest extends StatefulWidget {
  const PackageTest({
    super.key,
  });

  @override
  State<PackageTest> createState() => _PackageTestState();
}

class _PackageTestState extends State<PackageTest> {
  int _selcetedIndex = 0;
  bool _isLoadingInitialData = true;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    if (mzansiProfileProvider.user == null) {
      await MihDataHelperServices().loadUserDataWithBusinessesData(
        mzansiProfileProvider,
      );
    }
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: true,
        );
        FocusScope.of(context).unfocus();
        // Navigator.of(context).pop();
        // Navigator.of(context).popAndPushNamed(
        //   '/',
        //   arguments: AuthArguments(true, false),
        // );
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = Map();
    temp[const Icon(Icons.warning)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.inbox)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    temp[const Icon(Icons.outbond)] = () {
      setState(() {
        _selcetedIndex = 2;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  void showAlert() {
    MihAlertServices().inputErrorAlert(context);
  }

  List<Widget> getToolBody() {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    List<Widget> toolBodies = [
      const PackageToolZero(),
      PackageToolOne(
        user: profileProvider.user!,
        business: profileProvider.business,
      ),
      const PackageToolTwo(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Tool Zero",
      "Tool One",
      "Tool Two",
    ];
    return toolTitles;
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder:
          (BuildContext context, MzansiProfileProvider value, Widget? child) {
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appBody: getToolBody(),
          appToolTitles: getToolTitle(),
          selectedbodyIndex: _selcetedIndex,
          onIndexChange: (newValue) {
            setState(() {
              _selcetedIndex = newValue;
            });
            print("Index: $_selcetedIndex");
          },
        );
      },
    );
  }
}
