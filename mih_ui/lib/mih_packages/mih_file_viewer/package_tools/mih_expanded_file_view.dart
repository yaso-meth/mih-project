import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_file_viewer_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:mzansi_innovation_hub/mih_helpers/mih_utils_stub.dart'
    if (dart.library.js_interop) 'package:mzansi_innovation_hub/mih_helpers/mih_utils_web.dart';
import 'package:fl_downloader/fl_downloader.dart';

class MihExpandedFileView extends StatefulWidget {
  const MihExpandedFileView({super.key});

  @override
  State<MihExpandedFileView> createState() => _MihExpandedFileViewState();
}

class _MihExpandedFileViewState extends State<MihExpandedFileView> {
  late PdfViewerController pdfViewerController = PdfViewerController();
  int currentPageCount = 0;
  int currentPage = 0;
  double startZoomLevel = 1.0;
  double zoomOut = 0;
  int progress = 0;
  late StreamSubscription progressStream;

  void nativeFileDownload(String fileLink) async {
    var permission = await FlDownloader.requestPermission();
    if (permission == StoragePermissionStatus.granted) {
      try {
        showDialog(
          context: context,
          builder: (context) {
            return const Mihloadingcircle();
          },
        );
        await FlDownloader.download(fileLink);
        Navigator.of(context).pop();
      } on Exception catch (error) {
        Navigator.of(context).pop();
        print(error);
      }
    } else {
      print("denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(width, height),
    );
  }

  Widget getBody(double width, double height) {
    return Consumer<MihFileViewerProvider>(
      builder: (BuildContext context, MihFileViewerProvider fileViewerProvider,
          Widget? child) {
        bool isPDF =
            fileViewerProvider.filePath.split(".").last.toLowerCase() == "pdf";
        return Stack(
          children: [
            fileViewerProvider.filePath.split(".").last.toLowerCase() == "pdf"
                ? SizedBox(
                    width: width - zoomOut,
                    height: height - 70,
                    child: SfPdfViewerTheme(
                      data: SfPdfViewerThemeData(
                        backgroundColor: MihColors.primary(),
                      ),
                      child: SfPdfViewer.network(
                        fileViewerProvider.fileLink,
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
                  )
                : SizedBox(
                    width: width,
                    height: height - 70,
                    child: InteractiveViewer(
                      maxScale: 5.0,
                      //minScale: 0.,
                      child: Image.network(fileViewerProvider.fileLink),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 10,
                  shadowColor: Colors.black,
                  color: MihColors.secondary(),
                  borderRadius: BorderRadius.circular(25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isPDF)
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(0),
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
                              color: MihColors.primary(),
                            ),
                          ),
                        if (isPDF)
                          Text(
                            "$currentPage / $currentPageCount",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MihColors.primary(),
                            ),
                          ),
                        if (isPDF)
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(0),
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
                              color: MihColors.primary(),
                            ),
                          ),
                        if (isPDF)
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              if (zoomOut > 0) {
                                setState(() {
                                  zoomOut = zoomOut - 100;
                                });
                              } else {
                                setState(() {
                                  pdfViewerController.zoomLevel =
                                      startZoomLevel + 0.25;
                                  startZoomLevel =
                                      pdfViewerController.zoomLevel;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.zoom_in,
                              color: MihColors.primary(),
                            ),
                          ),
                        if (isPDF)
                          IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              if (pdfViewerController.zoomLevel > 1) {
                                setState(() {
                                  pdfViewerController.zoomLevel =
                                      startZoomLevel - 0.25;
                                  startZoomLevel =
                                      pdfViewerController.zoomLevel;
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
                              color: MihColors.primary(),
                            ),
                          ),
                        // IconButton(
                        //   iconSize: 30,
                        //   padding: const EdgeInsets.all(0),
                        //   onPressed: () {
                        //     printDocument();
                        //   },
                        //   icon: Icon(
                        //     Icons.print,
                        //     color: MihColors.secondary(),
                        //   ),
                        // ),
                        IconButton(
                          iconSize: 30,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            if (kIsWeb) {
                              openWebWindow(
                                  fileViewerProvider.fileLink, 'download');
                            } else {
                              nativeFileDownload(
                                fileViewerProvider.fileLink,
                              );
                            }
                          },
                          icon: Icon(
                            Icons.download,
                            color: MihColors.primary(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
