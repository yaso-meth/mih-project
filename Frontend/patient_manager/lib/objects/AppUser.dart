class AppUser {
  final int idUser;
  final String UserName;
  final int docOffice_id;
  final String fname;
  final String lname;
  final String title;

  const AppUser({
    required this.idUser,
    required this.UserName,
    required this.docOffice_id,
    required this.fname,
    required this.lname,
    required this.title,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'idUser': int idUser,
        'UserName': String UserName,
        'docOffice_id': int docOffice_id,
        'fname': String fname,
        'lname': String lname,
        'title': String title,
      } =>
        AppUser(
          idUser: idUser,
          UserName: UserName,
          docOffice_id: docOffice_id,
          fname: fname,
          lname: lname,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
