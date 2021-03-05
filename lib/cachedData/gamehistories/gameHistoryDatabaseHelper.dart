import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xplain/cachedData/gamehistories/gameHistoryDatabaseConverter.dart';
import 'package:xplain/models/gameHistory.dart';

class GHDatabaseHelper {
  
  static final _databaseName = "MygamesDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'mygames';
  
  static final columnId = '_id';
  static final columnGameID = 'gameid';
  static final columnGameName = 'gamename';
  static final columnCreatedAt = 'createdat';

  // make this a singleton class
  GHDatabaseHelper._privateConstructor();
  static final GHDatabaseHelper instance = GHDatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }
  
  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnGameID TEXT NOT NULL,
            $columnCreatedAt TEXT NOT NULL,
            $columnGameName TEXT NOT NULL
          )
          ''');
  }
  
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(GameHistory gameHistory) async {
    Database db = await instance.database;
    return await db.insert(table, GameHistoryDatabaseConverter.convertGameHistoryToDB(gameHistory));
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  Future<List<GameHistory>> queryAllRows() async {
    Database db = await instance.database;
    return (await db.query(table,)).map((e) => GameHistoryDatabaseConverter.convertDBtoGameHistory(e)).toList();
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other 
  // column values will be used to update the row.
  Future<int> update(GameHistory gameHistory) async {
    Database db = await instance.database;
    int id =gameHistory.dbID;
    return await db.update(table, GameHistoryDatabaseConverter.convertGameHistoryToDB(gameHistory), where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is 
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(GameHistory gameHistory) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [gameHistory.dbID]);
  }
}