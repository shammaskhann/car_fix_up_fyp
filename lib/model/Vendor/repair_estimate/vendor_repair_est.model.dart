//Model For Firebase Firestore
class VendorRepairEstimate {
  String title;
  String desc;
  double est_cost_min;
  double est_cost_max;

  VendorRepairEstimate({
    required this.title,
    required this.desc,
    required this.est_cost_min,
    required this.est_cost_max,
  });

  factory VendorRepairEstimate.fromJson(Map<String, dynamic> json) {
    return VendorRepairEstimate(
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      est_cost_min: (json['est_cost_min'] ?? 0).toDouble(),
      est_cost_max: (json['est_cost_max'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'desc': desc,
        'est_cost_min': est_cost_min,
        'est_cost_max': est_cost_max,
      };
}
