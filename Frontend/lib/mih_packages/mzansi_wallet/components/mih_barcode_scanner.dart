import 'dart:async';

import 'package:mzansi_innovation_hub/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihBarcodeScanner extends StatefulWidget {
  final TextEditingController cardNumberController;
  const MihBarcodeScanner({
    super.key,
    required this.cardNumberController,
  });

  @override
  State<MihBarcodeScanner> createState() => _MihBarcodeScannerState();
}

class _MihBarcodeScannerState extends State<MihBarcodeScanner>
    with WidgetsBindingObserver {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  StreamSubscription<Object>? _subscription;
  bool _isScannerStarting = false;
  bool barcodeScanned = false;

  void foundCode(BarcodeCapture bcode) {
    if (mounted &&
        barcodeScanned == false &&
        bcode.barcodes.isNotEmpty &&
        bcode.barcodes.first.rawValue != null) {
      setState(() {
        barcodeScanned = true;
        widget.cardNumberController.text = bcode.barcodes.first.rawValue!;
      });
      print(bcode.barcodes.first.rawValue);
      _scannerController.stop();
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_scannerController.value.hasCameraPermission) {
      return;
    }
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        if (!_scannerController.value.isRunning && !_isScannerStarting) {
          _isScannerStarting = true;
          _subscription = _scannerController.barcodes.listen(foundCode);
          unawaited(_scannerController.start().then((_) {
            _isScannerStarting = false;
          }));
        }
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_scannerController.stop().then((_) {
          _isScannerStarting = false;
        }));
    }
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await _scannerController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _scannerController.barcodes.listen(foundCode);
    unawaited(_scannerController.start());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: foundCode,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 500,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 5,
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MihButton(
                      onPressed: () {
                        _scannerController.stop();
                        Navigator.of(context).pop();
                      },
                      buttonColor: MihColors.getRedColor(context),
                      width: 100,
                      height: 50,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: MzansiInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     scannerController.stop();
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: const Text(
                  //     "Cancel",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 25,
                  //     ),
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.flip_camera_android,
                  //     size: 30,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
