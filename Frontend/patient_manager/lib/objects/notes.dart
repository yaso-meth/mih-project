class Note {
  final int idpatient_notes;
  final String note_name;
  final String note_text;
  final int patient_id;
  final String insert_date;

  const Note({
    required this.idpatient_notes,
    required this.note_name,
    required this.note_text,
    required this.patient_id,
    required this.insert_date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idpatient_notes": int idpatient_notes,
        "note_name": String note_name,
        "note_text": String note_text,
        "patient_id": int patient_id,
        "insert_date": String insert_date,
      } =>
        Note(
          idpatient_notes: idpatient_notes,
          note_name: note_name,
          note_text: note_text,
          patient_id: patient_id,
          insert_date: insert_date,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
