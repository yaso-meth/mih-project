class Note {
  final int idpatient_notes;
  final String note_name;
  final String note_text;
  final String insert_date;
  final String doc_office;
  final String doctor;
  final String app_id;

  const Note({
    required this.idpatient_notes,
    required this.note_name,
    required this.note_text,
    required this.insert_date,
    required this.doc_office,
    required this.doctor,
    required this.app_id,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idpatient_notes": int idpatient_notes,
        "note_name": String note_name,
        "note_text": String note_text,
        "insert_date": String insert_date,
        "doc_office": String doc_office,
        "doctor": String doctor,
        "app_id": String app_id,
      } =>
        Note(
          idpatient_notes: idpatient_notes,
          note_name: note_name,
          note_text: note_text,
          insert_date: insert_date,
          doc_office: doc_office,
          doctor: doctor,
          app_id: app_id,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
