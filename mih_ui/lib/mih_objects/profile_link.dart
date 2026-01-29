class ProfileLink {
  final int idprofile_links;
  final String app_id;
  final String business_id;
  final String destination;
  final String web_link;

  const ProfileLink({
    required this.idprofile_links,
    required this.app_id,
    required this.business_id,
    required this.destination,
    required this.web_link,
  });

  factory ProfileLink.fromJson(Map<String, dynamic> json) {
    return ProfileLink(
      idprofile_links: json['idprofile_links'],
      app_id: json['app_id'],
      business_id: json['business_id'],
      destination: json['destination'],
      web_link: json['web_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idprofile_links': idprofile_links,
      'app_id': app_id,
      'business_id': business_id,
      'destination': destination,
      'web_link': web_link,
    };
  }
}
