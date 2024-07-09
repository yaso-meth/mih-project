import 'package:flutter/material.dart';
import 'package:patient_manager/components/myMLTextInput.dart';
//import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/notes.dart';
import 'package:patient_manager/theme/mihTheme.dart';

class BuildNotesList extends StatefulWidget {
  final List<Note> notes;
  const BuildNotesList({
    super.key,
    required this.notes,
  });

  @override
  State<BuildNotesList> createState() => _BuildNotesListState();
}

class _BuildNotesListState extends State<BuildNotesList> {
  final noteTextController = TextEditingController();
  int indexOn = 0;

  void viewNotePopUp(String title, String note) {
    setState(() {
      noteTextController.text = note;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MyTheme().primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border:
                    Border.all(color: MyTheme().secondaryColor(), width: 5.0),
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyTheme().secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                    child: MyMLTextField(
                      controller: noteTextController,
                      hintText: "Note Details",
                      editable: false,
                      required: false,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  // SizedBox(
                  //   width: 300,
                  //   height: 100,
                  //   child: MyButton(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     buttonText: "Close",
                  //     buttonColor: Colors.blueAccent,
                  //     textColor: Colors.white,
                  //   ),
                  // )
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
                  color: MyTheme().errorColor(),
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
    if (widget.notes.isNotEmpty) {
      return SizedBox(
        height: 290.0,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: MyTheme().secondaryColor(),
            );
          },
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.notes[index].note_name,
                style: TextStyle(
                  color: MyTheme().secondaryColor(),
                ),
              ),
              subtitle: Text(
                "${widget.notes[index].insert_date}:\n${widget.notes[index].note_text}",
                style: TextStyle(
                  color: MyTheme().secondaryColor(),
                ),
              ), //Text(widget.notes[index].note_text),
              trailing: Icon(
                Icons.arrow_forward,
                color: MyTheme().secondaryColor(),
              ),
              onTap: () {
                viewNotePopUp(widget.notes[index].note_name,
                    "${widget.notes[index].insert_date}:\n${widget.notes[index].note_text}");
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
            "No Notes Available",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
