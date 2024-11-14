import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../mih_objects/arguments.dart';
import '../mih_pop_up_messages/mih_loading_circle.dart';

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
  MIHAction getActionButton() {
    return MIHAction(
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
