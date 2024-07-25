// ignore: file_names
class AppUser {
  final int idUser;
  final String email;
  final int docOffice_id;
  final String fname;
  final String lname;
  final String type;
  final String app_id;
  final String username;

  const AppUser(
    this.idUser,
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
      json['idUser'],
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
