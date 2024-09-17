// ignore: file_names
class Business {
  final String business_id;
  final String Name;
  final String type;
  final String registration_no;
  final String logo_name;
  final String logo_path;
  final String contact_no;
  final String bus_email;
  final String app_id;

  const Business(
    this.business_id,
    this.Name,
    this.type,
    this.registration_no,
    this.logo_name,
    this.logo_path,
    this.contact_no,
    this.bus_email,
    this.app_id,
  );

  factory Business.fromJson(dynamic json) {
    return Business(
      json['business_id'],
      json['Name'],
      json['type'],
      json['registration_no'],
      json['logo_name'],
      json['logo_path'],
      json['contact_no'],
      json['bus_email'],
      json['app_id'],
    );
  }
}
