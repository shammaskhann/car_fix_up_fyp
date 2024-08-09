import 'package:get/get.dart';

class UserController extends GetxController {
  late String _uid;
  late String _name;
  late String _email;
  late String _password;
  late String _contactNo;
  late String _userType;
  late String _deviceToken;

  // Getters
  String get uid => _uid;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get contactNo => _contactNo;
  String get userType => _userType;
  String get deviceToken => _deviceToken;

  // Setters
  set uid(String value) {
    _uid = value;
  }

  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  set contactNo(String value) {
    _contactNo = value;
  }

  set userType(String value) {
    _userType = value;
  }

  set deviceToken(String value) {
    _deviceToken = value;
  }

  void setInfo({
    required String uid,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String userType,
    required String deviceToken,
  }) {
    this.uid = uid;
    this.name = name;
    this.email = email;
    this.password = password;
    this.contactNo = contactNo;
    this.userType = userType;
    this.deviceToken = deviceToken;
  }
}
