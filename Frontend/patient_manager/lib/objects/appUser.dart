// ignore: file_names
class AppUser {
  final int idusers;
  final String email;
  // ignore: non_constant_identifier_names
  final int docOffice_id;
  final String fname;
  final String lname;
  final String type;
  // ignore: non_constant_identifier_names
  final String app_id;
  final String username;

  const AppUser(
    this.idusers,
    this.email,
    this.docOffice_id,
    this.fname,
    this.lname,
    this.type,
    this.app_id,
    this.username,
  );

  factory AppUser.fromJson(dynamic json) {
    return AppUser(
      json['idusers'],
      json['email'],
      json['docOffice_id'],
      json['fname'],
      json['lname'],
      json['type'],
      json['app_id'],
      json['username'],
    );
  }
}
