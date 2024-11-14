class PatientQueue {
  final int idpatient_queue;
  final String business_id;
  final String app_id;
  final String date_time;
  final String id_no;
  final String first_name;
  final String last_name;
  final String medical_aid_no;
  final String business_name;

  const PatientQueue({
    required this.idpatient_queue,
    required this.business_id,
    required this.app_id,
    required this.date_time,
    required this.id_no,
    required this.first_name,
    required this.last_name,
    required this.medical_aid_no,
    required this.business_name,
  });

  factory PatientQueue.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idpatient_queue": int idpatient_queue,
        'business_id': String business_id,
        'app_id': String app_id,
        'date_time': String date_time,
        'id_no': String id_no,
        'first_name': String first_name,
        'last_name': String last_name,
        'medical_aid_no': String medical_aid_no,
        'business_name': String business_name,
      } =>
        PatientQueue(
          idpatient_queue: idpatient_queue,
          business_id: business_id,
          app_id: app_id,
          date_time: date_time,
          id_no: id_no,
          first_name: first_name,
          last_name: last_name,
          medical_aid_no: medical_aid_no,
          business_name: business_name,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
