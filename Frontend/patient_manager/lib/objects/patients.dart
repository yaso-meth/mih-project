class Patient {
  final int idpatients;
  final String id_no;
  final String first_name;
  final String last_name;
  final String email;
  final String cell_no;
  final String medical_aid;
  final String medical_aid_name;
  final String medical_aid_no;
  final String medical_aid_main_member;
  final String medical_aid_code;
  final String medical_aid_scheme;
  final String address;
  final int doc_office_id;

  const Patient({
    required this.idpatients,
    required this.id_no,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.cell_no,
    required this.medical_aid,
    required this.medical_aid_name,
    required this.medical_aid_no,
    required this.medical_aid_main_member,
    required this.medical_aid_code,
    required this.medical_aid_scheme,
    required this.address,
    required this.doc_office_id,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idpatients": int idpatients,
        'id_no': String id_no,
        'first_name': String first_name,
        'last_name': String last_name,
        'email': String email,
        'cell_no': String cell_no,
        'medical_aid': String medical_aid,
        'medical_aid_name': String medical_aid_name,
        'medical_aid_no': String medical_aid_no,
        'medical_aid_main_member': String medical_aid_main_member,
        'medical_aid_code': String medical_aid_code,
        'medical_aid_scheme': String medical_aid_scheme,
        'address': String address,
        'doc_office_id': int doc_office_id,
      } =>
        Patient(
          idpatients: idpatients,
          id_no: id_no,
          first_name: first_name,
          last_name: last_name,
          email: email,
          cell_no: cell_no,
          medical_aid: medical_aid,
          medical_aid_name: medical_aid_name,
          medical_aid_no: medical_aid_no,
          medical_aid_main_member: medical_aid_main_member,
          medical_aid_code: medical_aid_code,
          medical_aid_scheme: medical_aid_scheme,
          address: address,
          doc_office_id: doc_office_id,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  String getIDNum() {
    return id_no;
  }
}
