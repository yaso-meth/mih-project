import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import "package:universal_html/html.dart" as html;
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

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

  void printDocument() async {
    print("Printing ${widget.arguments.path.split("/").last}");
    http.Response response = await http.get(Uri.parse(widget.arguments.link));
    var pdfData = response.bodyBytes;
    try {
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfData);
    } on Exception catch (_) {
      print("Print Error");
    }
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
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              size: 35,
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
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: IconButton(
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
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: IconButton(
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
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: isPDF,
          child: IconButton(
            onPressed: () {
              printDocument();
            },
            icon: Icon(
              Icons.print,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              size: 35,
            ),
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
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            size: 35,
          ),
        ),
        IconButton(
          onPressed: () {
            shareDocument();
          },
          icon: Icon(
            Icons.share,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            size: 35,
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
            backgroundColor:
                MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
        height: height,
        child: InteractiveViewer(
          maxScale: 5.0,
          //minScale: 0.,
          child: Image.network(widget.arguments.link),
        ),
      );
    }
    return MIHBody(
      borderOn: false,
      bodyItems: [fileViewer],
    );
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //pdfViewerController = widget.arguments.pdfViewerController!;
    pdfViewerController.addListener(onPageSelect);
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
    );
  }
}
