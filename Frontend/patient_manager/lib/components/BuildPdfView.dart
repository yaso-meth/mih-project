import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BuildPDFView extends StatefulWidget {
  final String pdfLink;
  const BuildPDFView({super.key, required this.pdfLink});

  @override
  State<BuildPDFView> createState() => _BuildPDFViewState();
}

class _BuildPDFViewState extends State<BuildPDFView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      child: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(widget.pdfLink),
          ),
        ],
      ),
    );
  }
}
