class AppUser {
  final int idusers;
  final String email;
  final int docOffice_id;

  const AppUser(
    this.idusers,
    this.email,
    this.docOffice_id,
  );

  factory AppUser.fromJson(dynamic json) {
    return AppUser(json['idusers'], json['email'], json['docOffice_id']);
  }
}
