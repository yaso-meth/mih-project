import 'package:flutter/material.dart';
import 'package:patient_manager/components/BuildFileView.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
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
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 800.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filename,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                      child: BuildFileView(
                          pdfLink:
                              "${AppEnviroment.baseFileUrl}/mih/$filename")),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: () {
                        html.window.open(
                            '${AppEnviroment.baseFileUrl}/mih/$filename',
                            'download');
                      },
                      buttonText: "Dowload",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
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
            return Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            );
          },
          itemCount: widget.files.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.files[index].file_name,
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              subtitle: Text(
                widget.files[index].insert_date,
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
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
