import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';

class MIHPrintPreview extends StatefulWidget {
  final PrintPreviewArguments arguments;
  const MIHPrintPreview({
    super.key,
    required this.arguments,
  });

  @override
  State<MIHPrintPreview> createState() => _MIHPrintPreviewState();
}

class _MIHPrintPreviewState extends State<MIHPrintPreview> {
  MihPackageAction getActionButton() {
    return MihPackageAction(
      icon: const Icon(
        Icons.close,
      ),
      iconSize: 35,
      onTap: () {
        Navigator.pop(context);
      },
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
    return PdfPreview(
      pdfFileName: widget.arguments.fileName,
      initialPageFormat: PdfPageFormat.a4,
      loadingWidget: const Mihloadingcircle(),
      actions: [getActionButton()],
      build: (format) => widget.arguments.pdfData,
    );
  }
}
