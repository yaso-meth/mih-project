// ignore: file_names
class AppUser {
  final int idusers;
  final String email;
  final int docOffice_id;
  final String fname;
  final String lname;
  final String title;

  const AppUser(
    this.idusers,
    this.email,
    this.docOffice_id,
    this.fname,
    this.lname,
    this.title,
  );

  factory AppUser.fromJson(dynamic json) {
    return AppUser(
      json['idusers'],
      json['email'],
      json['docOffice_id'],
      json['fname'],
      json['lname'],
      json['title'],
    );
  }
}
