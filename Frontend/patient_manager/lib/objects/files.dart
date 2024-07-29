class PFile {
  final int idpatient_files;
  final String file_path;
  final String file_name;
  final String insert_date;
  final String app_id;

  const PFile(
    this.idpatient_files,
    this.file_path,
    this.file_name,
    this.insert_date,
    this.app_id,
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
