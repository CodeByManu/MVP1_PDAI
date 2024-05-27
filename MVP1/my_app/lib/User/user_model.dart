import 'package:flutter/material.dart';
class UserSettings {
  String language;
  String transportationType;
  String alarmType;
  String password;
  String email;
  String username;

  UserSettings({
    required this.language,
    required this.transportationType,
    required this.alarmType,
    required this.password,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'transportationType': transportationType,
      'alarmType': alarmType,
      'password': password,
      'email': email,
      'username': username,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      language: map['language'],
      transportationType: map['transportationType'],
      alarmType: map['alarmType'],
      password: map['password'],
      email: map['email'],
      username: map['username'],
    );
  }
}

class UserSession extends ChangeNotifier {
  UserSettings? _currentUser;

  void setUser(UserSettings user) {
    _currentUser = user;
    notifyListeners();
  }

  UserSettings? getUser() {
    return _currentUser;
  }
}
