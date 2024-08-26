class Workshop {
  final String name;
  final String id;
  final String desc;
  final String area;
  final String city;
  final String imageUrl;
  final Location? loc;
  final String operationalTime;
  final String closeTime;

  Workshop({
    required this.name,
    required this.id,
    required this.desc,
    required this.area,
    required this.city,
    required this.imageUrl,
    required this.loc,
    required this.operationalTime,
    required this.closeTime,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
        name: json['name'] ?? '',
        id: json['id'] ?? '',
        desc: json['desc'] ?? '',
        area: json['area'] ?? '',
        city: json['city'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        loc: json['loc'] != null ? Location.fromJson(json['loc']) : null,
        operationalTime: json['operationalTime'] ?? '',
        closeTime: json['closeTime'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'desc': desc,
        'area': area,
        'city': city,
        'imageUrl': imageUrl,
        'loc': loc?.toJson(),
        'operationalTime': operationalTime,
        'closeTime': closeTime,
      };
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
