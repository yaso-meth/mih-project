// ignore: file_names
class AppUser {
  final int idUser;
  final String email;
  final String fname;
  final String lname;
  final String type;
  final String app_id;
  final String username;
  final String pro_pic_path;
  final String purpose;

  const AppUser(
    this.idUser,
    this.email,
    this.fname,
    this.lname,
    this.type,
    this.app_id,
    this.username,
    this.pro_pic_path,
    this.purpose,
  );

  factory AppUser.fromJson(dynamic json) {
    return AppUser(
      json['idUser'],
      json['email'],
      json['fname'],
      json['lname'],
      json['type'],
      json['app_id'],
      json['username'],
      json['pro_pic_path'],
      json['purpose'],
    );
  }
}
