//import 'package:flutter/foundation.dart';

class Routine {
  final String name;
  final int duration;
  final String description;
  final int weekday;

  Routine({required this.name, required this.duration, required this.description, required this.weekday});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
      'description': description,
      'weekday': weekday,
    };
  }
}


