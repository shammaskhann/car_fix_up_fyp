class WorkshopReview {
  final String reviewerName;
  final double rating;
  final String comment;
  final String datePosted;

  WorkshopReview({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.datePosted,
  });

  factory WorkshopReview.fromJson(Map<String, dynamic> json) {
    return WorkshopReview(
      reviewerName: json['reviewer_name'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      datePosted: json['datePosted']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'reviewerName': reviewerName,
        'rating': rating,
        'comment': comment,
        'datePosted': datePosted,
      };
}
