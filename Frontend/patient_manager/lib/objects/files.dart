class PFile {
  final int idpatient_files;
  final String file_path;
  final String file_name;
  final int patient_id;
  final String insert_date;

  const PFile(
    this.idpatient_files,
    this.file_path,
    this.file_name,
    this.patient_id,
    this.insert_date,
  );

  factory PFile.fromJson(dynamic json) {
    return PFile(
      json['idpatient_files'],
      json['file_path'],
      json['file_name'],
      json['patient_id'],
      json['insert_date'],
    );
  }
}
