class Appointment {
  final int idappointments;
  final String app_id;
  final String business_id;
  final String date_time;
  final String title;
  final String description;

  const Appointment({
    required this.idappointments,
    required this.app_id,
    required this.business_id,
    required this.date_time,
    required this.title,
    required this.description,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idappointments": int idappointments,
        'app_id': String app_id,
        'business_id': String business_id,
        'date_time': String date_time,
        'title': String title,
        'description': String description,
      } =>
        Appointment(
          idappointments: idappointments,
          app_id: app_id,
          business_id: business_id,
          date_time: date_time,
          title: title,
          description: description,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
