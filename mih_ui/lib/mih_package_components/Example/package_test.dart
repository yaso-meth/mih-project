import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_three.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_zero.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_one.dart';
import 'package:mzansi_innovation_hub/mih_package_components/Example/package_tools/package_tool_two.dart';
import 'package:flutter/material.dart';
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
  int _selectedIndex = 0;
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
      iconColor: MihColors.secondary(),
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
    temp[const Icon(Icons.link)] = () {
      setState(() {
        _selectedIndex = 0;
      });
    };
    temp[const Icon(Icons.warning)] = () {
      setState(() {
        _selectedIndex = 1;
      });
    };
    temp[const Icon(Icons.inbox)] = () {
      setState(() {
        _selectedIndex = 2;
      });
    };
    temp[const Icon(Icons.outbond)] = () {
      setState(() {
        _selectedIndex = 3;
      });
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: _selectedIndex,
    );
  }

  void showAlert() {
    MihAlertServices().inputErrorAlert(context);
  }

  List<Widget> getToolBody() {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    List<Widget> toolBodies = [
      const PackageToolThree(),
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
          packageActionButton: getAction(),
          packageTools: getTools(),
          packageToolBodies: getToolBody(),
          packageToolTitles: getToolTitle(),
          selectedBodyIndex: _selectedIndex,
          onIndexChange: (newValue) {
            setState(() {
              _selectedIndex = newValue;
            });
            print("Index: $_selectedIndex");
          },
        );
      },
    );
  }
}
