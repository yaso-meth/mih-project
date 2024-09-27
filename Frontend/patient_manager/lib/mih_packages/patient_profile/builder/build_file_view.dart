import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:universal_html/html.dart" as html;

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
  //late TextEditingController currentPageController = TextEditingController();
  double startZoomLevel = 1;

  String getExtType(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split(".").last;
  }

  String getFileName(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split("/").last;
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    if (getExtType(widget.path).toLowerCase() == "pdf") {
      //print(widget.pdfLink);
      return Expanded(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SfPdfViewerTheme(
                data: SfPdfViewerThemeData(
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                child: SfPdfViewer.network(
                  widget.link,
                  controller: pdfViewerController,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              width: 50,
              height: 50,
              child: IconButton.filled(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/file-veiwer',
                    arguments: FileViewArguments(
                      widget.link,
                      widget.path,
                    ),
                  );
                },
                icon: Icon(
                  Icons.fullscreen,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              width: 50,
              height: 50,
              child: IconButton.filled(
                onPressed: () {
                  html.window.open(
                      widget.link,
                      // '${AppEnviroment.baseFileUrl}/mih/$filePath',
                      'download');
                },
                icon: Icon(
                  Icons.download,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        // height: height,
        // padding: const EdgeInsets.all(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InteractiveViewer(
                //constrained: true,
                //clipBehavior: Clip.antiAlias,
                maxScale: 5.0,
                //minScale: 0.,
                child: Image.network(widget.link),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              width: 50,
              height: 50,
              child: IconButton.filled(
                onPressed: () {
                  //expandImage(width, height);
                  Navigator.of(context).pushNamed(
                    '/file-veiwer',
                    arguments: FileViewArguments(
                      widget.link,
                      widget.path,
                    ),
                  );
                },
                icon: Icon(
                  Icons.fullscreen,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              width: 50,
              height: 50,
              child: IconButton.filled(
                onPressed: () {
                  html.window.open(
                      widget.link,
                      // '${AppEnviroment.baseFileUrl}/mih/$filePath',
                      'download');
                },
                icon: Icon(
                  Icons.download,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
