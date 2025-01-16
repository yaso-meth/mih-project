import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MihBarcodeScanner extends StatefulWidget {
  final TextEditingController cardNumberController;
  const MihBarcodeScanner({
    super.key,
    required this.cardNumberController,
  });

  @override
  State<MihBarcodeScanner> createState() => _MihBarcodeScannerState();
}

class _MihBarcodeScannerState extends State<MihBarcodeScanner> {
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );

  void foundCode(BarcodeCapture bcode) {
    if (bcode.barcodes.first.rawValue != null) {
      setState(() {
        widget.cardNumberController.text = bcode.barcodes.first.rawValue!;
      });
      //print(bcode.barcodes.first.rawValue);
      scannerController.stop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            MobileScanner(
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
                      color: MzanziInnovationHub.of(context)!
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
                    child: MIHButton(
                      onTap: () {
                        scannerController.stop();
                        Navigator.of(context).pop();
                      },
                      buttonText: "Cancel",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
