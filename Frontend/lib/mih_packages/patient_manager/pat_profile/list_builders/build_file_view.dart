import 'dart:async';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'package:fl_downloader/fl_downloader.dart';

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

  int progress = 0;
  late StreamSubscription progressStream;

  void mihLoadingPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
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

  void printDocument() async {
    print("Printing ${widget.path.split("/").last}");
    http.Response response = await http.get(Uri.parse(widget.link));
    var pdfData = response.bodyBytes;
    Navigator.of(context).pushNamed(
      '/file-veiwer/print-preview',
      arguments: PrintPreviewArguments(
        pdfData,
        getFileName(
          widget.path,
        ),
      ),
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
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    debugPrint(widget.link);
    if (getExtType(widget.path).toLowerCase() == "pdf") {
      return SizedBox(
        height: 500,
        child: SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
            backgroundColor: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          child: SfPdfViewer.network(
            widget.link,
            controller: pdfViewerController,
            interactionMode: PdfInteractionMode.pan,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 500,
        child: InteractiveViewer(
          //constrained: true,
          //clipBehavior: Clip.antiAlias,
          maxScale: 5.0,
          //minScale: 0.,
          child: Image.network(widget.link),
        ),
      );
    }
  }
}
