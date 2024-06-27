import 'package:flutter/material.dart';
import 'package:patient_manager/components/BuildPdfView.dart';
import 'package:patient_manager/objects/files.dart';
import 'dart:js' as js;

class BuildFilesList extends StatefulWidget {
  final List<PFile> files;
  const BuildFilesList({
    super.key,
    required this.files,
  });

  @override
  State<BuildFilesList> createState() => _BuildFilesListState();
}

int indexOn = 0;

class _BuildFilesListState extends State<BuildFilesList> {
  @override
  Widget build(BuildContext context) {
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
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.files[index].file_name),
                      IconButton(
                        onPressed: () {
                          js.context.callMethod('open', [
                            'http://localhost:9000/mih/${widget.files[index].file_name}'
                          ]);
                          //print(object)
                        },
                        icon: const Icon(Icons.download),
                      ),
                    ],
                  ),
                  content: BuildPDFView(
                      pdfLink:
                          "http://localhost:9000/mih/${widget.files[index].file_name}"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"))
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
