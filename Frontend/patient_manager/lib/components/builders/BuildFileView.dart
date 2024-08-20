import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
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

  void expandFile(double width, double height) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                //borderRadius: BorderRadius.circular(25.0),
                // border: Border.all(
                //     color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                //     width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      getFileName(widget.path),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SfPdfViewerTheme(
                      data: SfPdfViewerThemeData(
                        backgroundColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                      child: SfPdfViewer.network(
                        widget.link,
                        controller: pdfViewerController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 2,
              width: 50,
              height: 50,
              child: IconButton.filled(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.fullscreen_exit,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 2,
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
        );
      },
    );
  }

  void expandImage(double width, double height) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                //borderRadius: BorderRadius.circular(25.0),
                // border: Border.all(
                //     color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                //     width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      getFileName(widget.path),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: InteractiveViewer(
                      maxScale: 5.0,
                      //minScale: 0.,
                      child: Image.network(widget.link),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 2,
              width: 50,
              height: 50,
              child: IconButton.filled(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.fullscreen_exit,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 2,
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
        );
      },
    );
  }

  String getExtType(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split(".").last;
  }

  String getFileName(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split("/").last;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    if (getExtType(widget.path).toLowerCase() == "pdf") {
      //print(widget.pdfLink);
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
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
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            width: 50,
            height: 50,
            child: IconButton.filled(
              onPressed: () {
                expandFile(width, height);
                //Navigator.pop(context);
              },
              icon: Icon(
                Icons.fullscreen,
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                size: 35,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  maxScale: 5.0,
                  //minScale: 0.,
                  child: Image.network(widget.link),
                ),
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            width: 50,
            height: 50,
            child: IconButton.filled(
              onPressed: () {
                expandImage(width, height);
                //Navigator.pop(context);
              },
              icon: Icon(
                Icons.fullscreen,
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                size: 35,
              ),
            ),
          ),
        ],
      );
    }
  }
}
