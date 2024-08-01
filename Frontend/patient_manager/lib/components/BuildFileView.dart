import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BuildFileView extends StatefulWidget {
  final String link;
  final String path;
  const BuildFileView({
    super.key,
    required this.link,
    required this.path,
  });

  @override
  State<BuildFileView> createState() => _BuildFileViewState();
}

class _BuildFileViewState extends State<BuildFileView> {
  late PdfViewerController pdfViewerController = PdfViewerController();

  String getExtType(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split(".").last;
  }

  @override
  Widget build(BuildContext context) {
    print(
        "${widget.link} ================================================================");
    if (getExtType(widget.path).toLowerCase() == "pdf") {
      //print(widget.pdfLink);
      return SizedBox(
        width: 700,
        child: Column(
          children: [
            Expanded(
              child: SfPdfViewer.network(
                widget.link,
                controller: pdfViewerController,
              ),
            ),
          ],
        ),
      );
    } else {
      print("Image");
      return InteractiveViewer(
        maxScale: 5.0,
        //minScale: 0.,
        child: Image.network(widget.link),
      );
    }
  }
}
