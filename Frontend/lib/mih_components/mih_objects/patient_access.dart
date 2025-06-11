class PatientAccess {
  final String business_id;
  final String business_name;
  final String app_id;
  final String fname;
  final String lname;
  final String id_no;
  final String type;
  final String status;
  final String approved_by;
  final String approved_on;
  final String requested_by;
  final String requested_on;

  const PatientAccess({
    required this.business_id,
    required this.business_name,
    required this.app_id,
    required this.fname,
    required this.lname,
    required this.id_no,
    required this.type,
    required this.status,
    required this.approved_by,
    required this.approved_on,
    required this.requested_by,
    required this.requested_on,
  });

  factory PatientAccess.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "business_id": String business_id,
        'business_name': String business_name,
        'app_id': String app_id,
        'fname': String fname,
        'lname': String lname,
        'id_no': String id_no,
        'type': String type,
        'status': String status,
        'approved_by': String approved_by,
        'approved_on': String approved_on,
        'requested_by': String requested_by,
        'requested_on': String requested_on,
      } =>
        PatientAccess(
          business_id: business_id,
          business_name: business_name,
          app_id: app_id,
          fname: fname,
          lname: lname,
          id_no: id_no,
          type: type,
          status: status,
          approved_by: approved_by,
          approved_on: approved_on,
          requested_by: requested_by,
          requested_on: requested_on,
        ),
      _ => throw const FormatException('Failed to load Patient Access List.'),
    };
  }
}
