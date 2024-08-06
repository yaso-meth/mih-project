// ignore: file_names
class BusinessUser {
  final int idbusiness_users;
  final String business_id;
  final String app_id;
  final String signature;
  final String title;

  const BusinessUser(
    this.idbusiness_users,
    this.business_id,
    this.app_id,
    this.signature,
    this.title,
  );

  factory BusinessUser.fromJson(dynamic json) {
    return BusinessUser(
      json['idbusiness_users'],
      json['business_id'],
      json['app_id'],
      json['signature'],
      json['title'],
    );
  }
}
