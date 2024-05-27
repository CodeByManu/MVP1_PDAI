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
      'CREATE TABLE user_settings(username TEXT PRIMARY KEY, email TEXT, password TEXT, language TEXT, transportationType TEXT, alarmType TEXT)',
    );
    await db.execute(
      'CREATE TABLE routine(id INTEGER PRIMARY KEY, userId TEXT, name TEXT, description TEXT, duration INTEGER, weekday TEXT, FOREIGN KEY(userId) REFERENCES user_settings(username))',
    );
  }

  Future<int> saveRoutine(
      Map<String, dynamic> routine, String? username) async {
    var dbClient = await db;
    routine['userId'] = username; // Add the userId to the routine map
    int res = await dbClient.insert('routine', routine);
    return res;
  }

  Future<List<Map<String, dynamic>>> getRoutines(String? username) async {
    var dbClient = await db;
    var result = await dbClient
        .query("routine", where: 'userId = ?', whereArgs: [username]);
    return result;
  }

  Future<void> updateRoutine(
      Map<String, dynamic> routine, String? username) async {
    var dbClient = await db;
    await dbClient.update('routine', routine,
        where: 'id = ? AND userId = ?', whereArgs: [routine['id'], username]);
  }

  Future<void> deleteRoutine(int id, String? username) async {
    var dbClient = await db;
    await dbClient.delete('routine',
        where: 'id = ? AND userId = ?', whereArgs: [id, username]);
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

  // CRUD operations: create, read, update, delete
}
