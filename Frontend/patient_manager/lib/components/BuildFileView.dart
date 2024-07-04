import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BuildFileView extends StatefulWidget {
  final String pdfLink;
  const BuildFileView({super.key, required this.pdfLink});

  @override
  State<BuildFileView> createState() => _BuildFileViewState();
}

class _BuildFileViewState extends State<BuildFileView> {
  late PdfViewerController pdfViewerController = PdfViewerController();

  String getExtType(String pdfLink) {
    //print(pdfLink.split(".")[1]);
    return pdfLink.split(".")[1];
  }

  @override
  Widget build(BuildContext context) {
    if (getExtType(widget.pdfLink).toLowerCase() == "pdf") {
      return SizedBox(
        width: 700,
        child: Column(
          children: [
            Expanded(
              child: SfPdfViewer.network(
                widget.pdfLink,
                controller: pdfViewerController,
              ),
            ),
          ],
        ),
      );
    } else {
      return InteractiveViewer(
        maxScale: 5.0,
        //minScale: 0.,
        child: Image.network(widget.pdfLink),
      );
    }
  }
}
