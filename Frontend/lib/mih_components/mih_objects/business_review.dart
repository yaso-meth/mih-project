class BusinessReview {
  final int idbusiness_ratings;
  final String app_id;
  final String business_id;
  final String rating_title;
  final String rating_description;
  final String rating_score;
  final String date_time;
  final String reviewer;

  BusinessReview({
    required this.idbusiness_ratings,
    required this.app_id,
    required this.business_id,
    required this.rating_title,
    required this.rating_description,
    required this.rating_score,
    required this.date_time,
    required this.reviewer,
  });
  factory BusinessReview.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "idbusiness_ratings": int idbusiness_ratings,
        "app_id": String app_id,
        "business_id": String business_id,
        "rating_title": String rating_title,
        "rating_description": String rating_description,
        "rating_score": String rating_score,
        "date_time": String date_time,
        "reviewer": String reviewer,
      } =>
        BusinessReview(
          idbusiness_ratings: idbusiness_ratings,
          app_id: app_id,
          business_id: business_id,
          rating_title: rating_title,
          rating_description: rating_description,
          rating_score: rating_score,
          date_time: date_time,
          reviewer: reviewer,
        ),
      _ => throw const FormatException('Failed to load loyalty card objects'),
    };
  }
}
