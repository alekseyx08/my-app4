import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class DBProvider {
  // Реализация паттерна "Одиночка" (Singleton)
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(); // Ленивая инициализация
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UsersDB.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER
          )
        ''');
      },
    );
  }

  // CRUD операции
  Future<int> insertUser(UserModel newUser) async {
    final db = await database;
    return await db.insert("Users", newUser.toMap());
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> res = await db.query("Users");
    return res.isNotEmpty ? res.map((c) => UserModel.fromMap(c)).toList() : [];
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete("Users", where: "id = ?", whereArgs: [id]);
  }
}
