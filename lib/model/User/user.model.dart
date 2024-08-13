class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String deviceToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.deviceToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      deviceToken: json['deviceToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'deviceToken': deviceToken,
    };
  }
}
