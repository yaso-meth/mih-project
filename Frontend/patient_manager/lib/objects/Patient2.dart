class Patient2 {
  final int idpatients;
  final String id_no;
  final String first_name;
  final String last_name;
  final String email;
  final String cell_no;
  final String medical_aid_name;
  final String medical_aid_no;
  final String medical_aid_scheme;
  final String address;
  final int doc_office_id;

  const Patient2(
    this.idpatients,
    this.id_no,
    this.first_name,
    this.last_name,
    this.email,
    this.cell_no,
    this.medical_aid_name,
    this.medical_aid_no,
    this.medical_aid_scheme,
    this.address,
    this.doc_office_id,
  );

  factory Patient2.fromJson(dynamic json) {
    return Patient2(
      json['idpatients'],
      json['id_no'],
      json['first_name'],
      json['last_name'],
      json['email'],
      json['cell_no'],
      json['medical_aid_name'],
      json['medical_aid_no'],
      json['medical_aid_scheme'],
      json['address'],
      json['docOffice_id'],
    );
  }

  String getIDNum() {
    return id_no;
  }
}
