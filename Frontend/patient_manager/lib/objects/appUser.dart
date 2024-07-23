// ignore: file_names
class AppUser {
  final int idusers;
  final String email;
  final int docOffice_ID;
  final String fname;
  final String lname;
  final String title;
  final String app_id;

  const AppUser(
    this.idusers,
    this.email,
    this.docOffice_ID,
    this.fname,
    this.lname,
    this.title,
    this.app_id,
  );

  factory AppUser.fromJson(dynamic json) {
    return AppUser(
      json['idusers'],
      json['email'],
      json['docOffice_ID'],
      json['fname'],
      json['lname'],
      json['title'],
      json['app_id'],
    );
  }
}
