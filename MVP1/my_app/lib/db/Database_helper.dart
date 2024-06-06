import 'dart:ffi';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../User/user_model.dart';
//import '../Routines/routine_model.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await setDB();
    return _db!;
  }

  DatabaseHelper.internal();

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = p.join(directory.path, 'routineDB');
    var dB = await openDatabase(path, version: 3, onCreate: _onCreate);

    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE user_settings(username TEXT PRIMARY KEY, email TEXT, password TEXT, language TEXT, transportationType TEXT, alarmType TEXT, latitude INTEGER, longitude INTEGER)',
    );
    await db.execute(
      'CREATE TABLE routine(routineId INTEGER PRIMARY KEY, timeofarrival INTEGER, username TEXT, name TEXT, weekday INTEGER, destination TEXT, dep_lat INTEGER, dep_lon INTEGER, des_lat INTEGER, des_lon INTEGER, FOREIGN KEY(username) REFERENCES user_settings(username))',
    );
    await db.execute(
      'CREATE TABLE activitie(id INTEGER PRIMARY KEY, name TEXT, description TEXT, duration INTEGER, RoutineId INTEGER, FOREIGN KEY(RoutineId) REFERENCES routine(routineId))',
    );
  }

  Future<int> saveRoutine(String? username, String? name, int? weekday, String? destination, double deslat, double deslon, double deplat, double deplon, int time) async {
    var dbClient = await db;
    Map<String, dynamic> routine;
    routine = {
      'username': username,
      'name': name,
      'weekday': weekday,
      'destination': destination,
      'des_lat': deslat,
      'des_lon': deslon,
      'dep_lat': deplat,
      'dep_lon': deplon,
      'timeofarrival': time,
    };
    int res = await dbClient.insert('routine', routine);

    return res;
  }

  Future<int> saveActivitie(
      String? name, String? description, int? duration, int routineId) async {
    var dbClient = await db;
    Map<String, dynamic> activitie;
    activitie = {
      'name': name,
      'description': description,
      'duration': duration,
      'RoutineId': routineId,
    };
    int res = await dbClient.insert('activitie', activitie);

    return res;
  }

  Future<List<Map<String, dynamic>>> getRoutines(
      String? username) async {
    var dbClient = await db;
    var result = await dbClient.query("routine",
        where: 'username = ?', whereArgs: [username]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getActivities(int routineId) async {
    var dbClient = await db;
    var result = await dbClient.query("activitie",
        where: 'RoutineId = ?', whereArgs: [routineId]);
    return result;
  }

  Future<void> updateRoutine(
      Map<String, dynamic> routine, String? username) async {
    var dbClient = await db;
    await dbClient.update('routine', routine,
        where: 'routineId = ? AND username = ?',
        whereArgs: [routine['routineId'], username]);
  }

  Future<void> updateActivitie(
      Map<String, dynamic> activitie, int? routineId) async {
    var dbClient = await db;
    await dbClient.update('activitie', activitie,
        where: 'RoutineId = ?', whereArgs: [routineId]);
  }

  Future<void> deleteRoutine(int id, String? username) async {
    var dbClient = await db;
    await dbClient.delete('routine',
        where: 'routineId = ? AND username = ?', whereArgs: [id, username]);
  }

  Future<void> deleteActivitie(int id) async {
    var dbClient = await db;
    await dbClient.delete('activitie', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertUserSettings(UserSettings userSettings) async {
    var dbClient = await db;
    await dbClient.insert('user_settings', userSettings.toMap());
  }

  Future<UserSettings> getUserSettings(String? username) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      'user_settings',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return UserSettings.fromMap(maps.first);
    } else {
      throw Exception('No user found for username: $username');
    }
  }

  Future<List<Map<String, Object?>>> getRoutinesLocations(String? username) async {
    var dbClient = await db;
    var result = await dbClient.query("routines",
        columns: ['des_lat', 'des_lon'],
        where: 'username = ?',
        whereArgs: [username]);
    return result;
  }

  
}
