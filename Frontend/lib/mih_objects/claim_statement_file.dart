class ClaimStatementFile {
  final int idclaim_statement_file;
  final String app_id;
  final String business_id;
  final String insert_date;
  final String file_path;
  final String file_name;

  const ClaimStatementFile({
    required this.idclaim_statement_file,
    required this.app_id,
    required this.business_id,
    required this.insert_date,
    required this.file_path,
    required this.file_name,
  });

  factory ClaimStatementFile.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idclaim_statement_file": int idclaim_statement_file,
        'app_id': String app_id,
        'business_id': String business_id,
        'insert_date': String insert_date,
        'file_path': String file_path,
        'file_name': String file_name,
      } =>
        ClaimStatementFile(
          idclaim_statement_file: idclaim_statement_file,
          app_id: app_id,
          business_id: business_id,
          insert_date: insert_date,
          file_path: file_path,
          file_name: file_name,
        ),
      _ =>
        throw const FormatException('Failed to load Claim Statement Object.'),
    };
  }
}
