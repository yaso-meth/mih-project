class UserConsent {
  String app_id;
  DateTime privacy_policy_accepted;
  DateTime terms_of_services_accepted;

  UserConsent({
    required this.app_id,
    required this.privacy_policy_accepted,
    required this.terms_of_services_accepted,
  });

  factory UserConsent.fromJson(Map<String, dynamic> json) {
    return UserConsent(
      app_id: json['app_id'],
      privacy_policy_accepted: DateTime.parse(json['privacy_policy_accepted']),
      terms_of_services_accepted:
          DateTime.parse(json['terms_of_services_accepted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_id': app_id,
      'privacy_policy_accepted': privacy_policy_accepted.toIso8601String(),
      'terms_of_services_accepted':
          terms_of_services_accepted.toIso8601String(),
    };
  }
}
