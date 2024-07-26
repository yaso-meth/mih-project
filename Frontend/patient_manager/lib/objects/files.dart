class PFile {
  final int idpatient_files;
  final String file_path;
  final String file_name;
  final String app_id;
  final String insert_date;

  const PFile(
    this.idpatient_files,
    this.file_path,
    this.file_name,
    this.app_id,
    this.insert_date,
  );

  factory PFile.fromJson(dynamic json) {
    return PFile(
      json['idpatient_files'],
      json['file_path'],
      json['file_name'],
      json['insert_date'],
      json['app_id'],
    );
  }
}
