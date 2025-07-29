class BookmarkedBusiness {
  final int idbookmarked_businesses;
  final String app_id;
  final String business_id;
  final String created_date;

  BookmarkedBusiness({
    required this.idbookmarked_businesses,
    required this.app_id,
    required this.business_id,
    required this.created_date,
  });
  factory BookmarkedBusiness.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idbookmarked_businesses": int idbookmarked_businesses,
        "app_id": String app_id,
        "business_id": String business_id,
        "created_date": String created_date,
      } =>
        BookmarkedBusiness(
          idbookmarked_businesses: idbookmarked_businesses,
          app_id: app_id,
          business_id: business_id,
          created_date: created_date,
        ),
      _ => throw const FormatException(
          'Failed to load bookmarked business objects'),
    };
  }
}
