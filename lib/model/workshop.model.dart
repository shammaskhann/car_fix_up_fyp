class Workshop {
  final String name;
  final String id;
  final String desc;
  final String area;
  final String city;
  final String imageUrl;

  Workshop({
    required this.name,
    required this.id,
    required this.desc,
    required this.area,
    required this.city,
    required this.imageUrl,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      name: json['name'],
      id: json['id'],
      desc: json['desc'],
      area: json['area'],
      city: json['city'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'desc': desc,
        'area': area,
        'city': city,
        'imageUrl': imageUrl,
      };
}
