// ignore: file_names
class BusinessEmployee {
  final String business_id;
  final String app_id;
  final String title;
  final String access;
  final String fname;
  final String lname;
  final String email;
  final String username;

  const BusinessEmployee(
    this.business_id,
    this.app_id,
    this.title,
    this.access,
    this.fname,
    this.lname,
    this.email,
    this.username,
  );

  factory BusinessEmployee.fromJson(dynamic json) {
    return BusinessEmployee(
      json['business_id'],
      json['app_id'],
      json['title'],
      json['access'],
      json['fname'],
      json['lname'],
      json['email'],
      json['username'],
    );
  }
}
