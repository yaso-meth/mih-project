class AccessRequest {
  final int idpatient_queue;
  final String business_id;
  final String app_id;
  final String date_time;
  final String access;
  final String Name;
  final String type;
  final String logo_path;

  const AccessRequest({
    required this.idpatient_queue,
    required this.business_id,
    required this.app_id,
    required this.date_time,
    required this.access,
    required this.Name,
    required this.type,
    required this.logo_path,
  });

  factory AccessRequest.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idpatient_queue": int idpatient_queue,
        'business_id': String business_id,
        'app_id': String app_id,
        'date_time': String date_time,
        'access': String access,
        'Name': String Name,
        'type': String type,
        'logo_path': String logo_path,
      } =>
        AccessRequest(
          idpatient_queue: idpatient_queue,
          business_id: business_id,
          app_id: app_id,
          date_time: date_time,
          access: access,
          Name: Name,
          type: type,
          logo_path: logo_path,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
