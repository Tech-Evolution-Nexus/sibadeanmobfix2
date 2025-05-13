import 'package:sibadeanmob_v2_fix/models/AuthUserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user_data.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        email TEXT,
        role TEXT,
        nama_lengkap TEXT,
        nik TEXT,
        no_kk TEXT,
        access_token TEXT,
        avatar TEXT

      )
    ''');
  }

  Future<void> insertUser(AuthUserModel user) async {
    final db = await database;
    // await db.delete('user');
    await db.insert(
      'user',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AuthUserModel>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');

    return List.generate(maps.length, (i) {
      return AuthUserModel(
        id: maps[i]['id'],
        role: maps[i]['role'],
        email: maps[i]['email'],
        nama_lengkap: maps[i]['nama_lengkap'],
        nik: maps[i]['nik'],
        no_kk: maps[i]['no_kk'],
        access_token: maps[i]['access_token'],
        avatar: maps[i]['avatar'],
      );
    });
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete('user');
  }
}
