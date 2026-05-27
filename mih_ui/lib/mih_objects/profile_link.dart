class ProfileLink {
  final int idprofile_links;
  final String app_id;
  final String business_id;
  final String site_name;
  final String custom_name;
  final String destination;
  final int order;

  const ProfileLink({
    required this.idprofile_links,
    required this.app_id,
    required this.business_id,
    required this.site_name,
    required this.custom_name,
    required this.destination,
    required this.order,
  });

  factory ProfileLink.fromJson(Map<String, dynamic> json) {
    return ProfileLink(
      idprofile_links: json['idprofile_links'],
      app_id: json['app_id'],
      business_id: json['business_id'],
      site_name: json['site_name'],
      custom_name: json['custom_name'],
      destination: json['destination'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idprofile_links': idprofile_links,
      'app_id': app_id,
      'business_id': business_id,
      'site_name': site_name,
      'custom_name': custom_name,
      'destination': destination,
      'order': order,
    };
  }
}
