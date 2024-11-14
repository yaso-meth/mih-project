class AccessRequest {
  final int idpatient_queue;
  final String business_id;
  final String app_id;
  final String date_time;
  final String access;
  final String revoke_date;
  final String Name;
  final String type;
  final String logo_path;
  final String contact_no;

  const AccessRequest({
    required this.idpatient_queue,
    required this.business_id,
    required this.app_id,
    required this.date_time,
    required this.access,
    required this.revoke_date,
    required this.Name,
    required this.type,
    required this.logo_path,
    required this.contact_no,
  });

  factory AccessRequest.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idpatient_queue": int idpatient_queue,
        'business_id': String business_id,
        'app_id': String app_id,
        'date_time': String date_time,
        'access': String access,
        'revoke_date': String revoke_date,
        'Name': String Name,
        'type': String type,
        'logo_path': String logo_path,
        'contact_no': String contact_no,
      } =>
        AccessRequest(
          idpatient_queue: idpatient_queue,
          business_id: business_id,
          app_id: app_id,
          date_time: date_time,
          access: access,
          revoke_date: revoke_date,
          Name: Name,
          type: type,
          logo_path: logo_path,
          contact_no: contact_no,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
