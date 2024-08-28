import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:universal_html/html.dart" as html;

class FullScreenFileViewer extends StatefulWidget {
  final FileViewArguments arguments;
  const FullScreenFileViewer({
    super.key,
    required this.arguments,
  });

  @override
  State<FullScreenFileViewer> createState() => _FullScreenFileViewerState();
}

class _FullScreenFileViewerState extends State<FullScreenFileViewer> {
  late PdfViewerController pdfViewerController = PdfViewerController();
  int currentPageCount = 0;
  int currentPage = 0;
  double startZoomLevel = 1.0;
  double zoomOut = 0;

  String getExtType(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split(".").last;
  }

  String getFileName(String path) {
    //print(pdfLink.split(".")[1]);
    return path.split("/").last;
  }

  void onPageSelect() {
    setState(() {
      currentPage = pdfViewerController.pageNumber;
    });
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pdfViewerController.addListener(onPageSelect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;

    if (getExtType(widget.arguments.path).toLowerCase() == "pdf") {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: width,
                padding: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      width: width - zoomOut,
                      height: height - 70,
                      child: SfPdfViewerTheme(
                        data: SfPdfViewerThemeData(
                          backgroundColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                        ),
                        child: SfPdfViewer.network(
                          widget.arguments.link,
                          controller: pdfViewerController,
                          initialZoomLevel: startZoomLevel,
                          pageSpacing: 2,
                          maxZoomLevel: 5,
                          interactionMode: PdfInteractionMode.pan,
                          onDocumentLoaded: (details) {
                            setState(() {
                              currentPage = pdfViewerController.pageNumber;
                              currentPageCount = pdfViewerController.pageCount;
                            });
                          },
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
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.fullscreen_exit,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    size: 35,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 2,
                //width: 50,
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        pdfViewerController.previousPage();
                        //print(pdfViewerController.);
                        //if (pdfViewerController.pageNumber > 1) {
                        setState(() {
                          currentPage = pdfViewerController.pageNumber;
                        });
                        // }
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        size: 35,
                      ),
                    ),
                    // SizedBox(
                    //   width: 40,
                    //   height: 40,
                    //   child: MIHTextField(
                    //       controller: cuntrController,
                    //       hintText: "",
                    //       editable: true,
                    //       required: false),
                    // ),
                    Text(
                      "$currentPage / $currentPageCount",
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        pdfViewerController.nextPage();
                        //print(pdfViewerController.pageNumber);
                        //if (pdfViewerController.pageNumber < currentPageCount) {
                        setState(() {
                          currentPage = pdfViewerController.pageNumber;
                        });
                        //}
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        size: 35,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (zoomOut > 0) {
                          setState(() {
                            zoomOut = zoomOut - 100;
                          });
                        } else {
                          setState(() {
                            pdfViewerController.zoomLevel =
                                startZoomLevel + 0.25;
                            startZoomLevel = pdfViewerController.zoomLevel;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.zoom_in,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        size: 35,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (pdfViewerController.zoomLevel > 1) {
                          setState(() {
                            pdfViewerController.zoomLevel =
                                startZoomLevel - 0.25;
                            startZoomLevel = pdfViewerController.zoomLevel;
                          });
                        } else {
                          if (zoomOut < (width - 100)) {
                            setState(() {
                              zoomOut = zoomOut + 100;
                            });
                          }
                        }
                      },
                      icon: Icon(
                        Icons.zoom_out,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        size: 35,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        html.window.open(
                            widget.arguments.link,
                            // '${AppEnviroment.baseFileUrl}/mih/$filePath',
                            'download');
                      },
                      icon: Icon(
                        Icons.download,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50.0),
              width: width,
              // height: height,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                //borderRadius: BorderRadius.circular(25.0),
                // border: Border.all(
                //     color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                //     width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: InteractiveViewer(
                      maxScale: 5.0,
                      //minScale: 0.,
                      child: Image.network(widget.arguments.link),
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
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.fullscreen_exit,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 2,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  html.window.open(
                      widget.arguments.link,
                      // '${AppEnviroment.baseFileUrl}/mih/$filePath',
                      'download');
                },
                icon: Icon(
                  Icons.download,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
