import 'dart:ffi';

import 'package:flutter/material.dart';
class UserSettings {
  String language;
  String transportationType;
  String alarmType;
  String password;
  String email;
  String username;
  double latitude;
  double longitude;

  UserSettings({
    required this.language,
    required this.transportationType,
    required this.alarmType,
    required this.password,
    required this.email,
    required this.username,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'transportationType': transportationType,
      'alarmType': alarmType,
      'password': password,
      'email': email,
      'username': username,
      'latitude': latitude,
      'longitude': longitude,
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
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class UserSession extends ChangeNotifier {
  UserSettings? _currentUser;

  void setUser(UserSettings user) {
    _currentUser = user;
    notifyListeners();
  }

  void removeUser() {
    _currentUser = null;
    notifyListeners();
  }

  UserSettings? getUser() {
    return _currentUser;
  }
}
