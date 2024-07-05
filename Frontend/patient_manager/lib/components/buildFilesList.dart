import 'package:flutter/material.dart';
import 'package:patient_manager/components/BuildFileView.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/files.dart';
//import 'dart:js' as js;
import "package:universal_html/html.dart" as html;

class BuildFilesList extends StatefulWidget {
  final List<PFile> files;
  const BuildFilesList({
    super.key,
    required this.files,
  });

  @override
  State<BuildFilesList> createState() => _BuildFilesListState();
}

class _BuildFilesListState extends State<BuildFilesList> {
  int indexOn = 0;

  void viewFilePopUp(String filename) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 800.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.blueAccent, width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filename,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                      child: BuildFileView(
                          pdfLink: "http://localhost:9000/mih/$filename")),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: () {
                        html.window.open(
                            'http://localhost:9000/mih/$filename', 'download');
                      },
                      buttonText: "Dowload",
                      buttonColor: Colors.blueAccent,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.files.isNotEmpty) {
      return SizedBox(
        height: 290.0,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemCount: widget.files.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.files[index].file_name,
              ),
              subtitle: Text(widget.files[index].insert_date),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                viewFilePopUp(widget.files[index].file_name);
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox(
        height: 290.0,
        child: Center(
          child: Text(
            "No Files Available",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
