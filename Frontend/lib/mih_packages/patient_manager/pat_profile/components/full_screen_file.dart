import 'dart:async';

import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import '../../../../main.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;

import 'package:printing/printing.dart';
import 'package:fl_downloader/fl_downloader.dart';

import '../../../../mih_components/mih_layout/mih_action.dart';
import '../../../../mih_components/mih_layout/mih_body.dart';
import '../../../../mih_components/mih_layout/mih_header.dart';
import '../../../../mih_components/mih_layout/mih_layout_builder.dart';

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

  int progress = 0;
  late StreamSubscription progressStream;

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

  void printDocument() async {
    print("Printing ${widget.arguments.path.split("/").last}");
    http.Response response = await http.get(Uri.parse(widget.arguments.link));
    var pdfData = response.bodyBytes;
    Navigator.of(context).pushNamed(
      '/file-veiwer/print-preview',
      arguments: pdfData,
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => PdfPreview(
    //       initialPageFormat: PdfPageFormat.a4,
    //       build: (format) => pdfData,
    //     ),
    //   ),
    // );
    // try {
    //   await Printing.layoutPdf(
    //       onLayout: (PdfPageFormat format) async => pdfData);
    // } on Exception catch (_) {
    //   print("Print Error");
    // }
  }

  void shareDocument() async {
    http.Response response = await http.get(Uri.parse(widget.arguments.link));
    var pdfData = response.bodyBytes;
    await Printing.sharePdf(
        bytes: pdfData, filename: widget.arguments.path.split("/").last);
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(
        Icons.fullscreen_exit,
      ),
      iconSize: 35,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  MIHHeader getHeader(double width) {
    bool isPDF;
    if (getExtType(widget.arguments.path).toLowerCase() == "pdf") {
      isPDF = true;
    } else {
      isPDF = false;
    }
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        Visibility(
          visible: isPDF,
          child: IconButton(
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
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: Text(
            "$currentPage / $currentPageCount",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: IconButton(
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
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (zoomOut > 0) {
                setState(() {
                  zoomOut = zoomOut - 100;
                });
              } else {
                setState(() {
                  pdfViewerController.zoomLevel = startZoomLevel + 0.25;
                  startZoomLevel = pdfViewerController.zoomLevel;
                });
              }
            },
            icon: Icon(
              Icons.zoom_in,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: IconButton(
            iconSize: 30,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (pdfViewerController.zoomLevel > 1) {
                setState(() {
                  pdfViewerController.zoomLevel = startZoomLevel - 0.25;
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
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
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
        //     color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        //   ),
        // ),
        IconButton(
          iconSize: 30,
          padding: const EdgeInsets.all(0),
          onPressed: () {
            if (MzansiInnovationHub.of(context)!.theme.getPlatform() == "Web") {
              html.window.open(
                  widget.arguments.link,
                  // '${AppEnviroment.baseFileUrl}/mih/$filePath',
                  'download');
            } else {
              nativeFileDownload(
                widget.arguments.link,
              );
            }
          },
          icon: Icon(
            Icons.download,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
      ],
    );
  }

  MIHBody getBody(double width, double height) {
    Widget fileViewer;
    if (getExtType(widget.arguments.path).toLowerCase() == "pdf") {
      fileViewer = SizedBox(
        width: width - zoomOut,
        height: height - 70,
        child: SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
            backgroundColor: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
      );
    } else {
      fileViewer = SizedBox(
        width: width,
        height: height - 70,
        child: InteractiveViewer(
          maxScale: 5.0,
          //minScale: 0.,
          child: Image.network(widget.arguments.link),
        ),
      );
    }
    return MIHBody(
      borderOn: false,
      bodyItems: [
        fileViewer,
      ],
    );
  }

  void mihLoadingPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }

  void nativeFileDownload(String fileLink) async {
    var permission = await FlDownloader.requestPermission();
    if (permission == StoragePermissionStatus.granted) {
      try {
        mihLoadingPopUp();
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
  void dispose() {
    pdfViewerController.dispose();
    progressStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //pdfViewerController = widget.arguments.pdfViewerController!;
    pdfViewerController.addListener(onPageSelect);
    FlDownloader.initialize();
    progressStream = FlDownloader.progressStream.listen((event) {
      if (event.status == DownloadStatus.successful) {
        setState(() {
          progress = event.progress;
        });
        //Navigator.of(context).pop();
        print("Progress $progress%: Success Downloading");
        FlDownloader.openFile(filePath: event.filePath);
      } else if (event.status == DownloadStatus.failed) {
        print("Progress $progress%: Error Downloading");
      } else if (event.status == DownloadStatus.running) {
        print("Progress $progress%: Download Running");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    double width = size.width;
    double height = size.height;

    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(width),
      secondaryActionButton: null,
      body: getBody(width, height),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
