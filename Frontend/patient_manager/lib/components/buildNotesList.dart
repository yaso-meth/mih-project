import 'package:flutter/material.dart';
import 'package:patient_manager/objects/notes.dart';

class BuildNotesList extends StatefulWidget {
  final List<Note> notes;
  const BuildNotesList({
    super.key,
    required this.notes,
  });

  @override
  State<BuildNotesList> createState() => _BuildNotesListState();
}

int indexOn = 0;

class _BuildNotesListState extends State<BuildNotesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            widget.notes[index].note_name,
          ),
          subtitle: Text(widget.notes[index].note_text),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {},
        );
      },
    );
  }
}
