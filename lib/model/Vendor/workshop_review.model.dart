// class WorkshopReview {
//   final String reviewerName;
//   final double rating;
//   final String comment;
//   final String datePosted;
//   final Location loc;

//   WorkshopReview({
//     required this.reviewerName,
//     required this.rating,
//     required this.comment,
//     required this.datePosted,
//     required this.loc,
//   });

//   factory WorkshopReview.fromJson(Map<String, dynamic> json) {
//     return WorkshopReview(
//       reviewerName: json['reviewer_name'] ?? '',
//       rating: (json['rating'] ?? 0).toDouble(),
//       comment: json['comment'] ?? '',
//       datePosted: json['datePosted']?.toString() ?? '',
//       loc: Location.fromJson(json['loc']),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'reviewerName': reviewerName,
//         'rating': rating,
//         'comment': comment,
//         'datePosted': datePosted,
//         'loc': loc.toJson(),
//       };
// }

// class Location {
//   final double lat;
//   final double lng;

//   Location({
//     required this.lat,
//     required this.lng,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       lat: (json['lat'] ?? 0).toDouble(),
//       lng: (json['lng'] ?? 0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'lat': lat,
//         'lng': lng,
//       };
// }
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
