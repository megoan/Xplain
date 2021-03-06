import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xplain/cachedData/questions/questionDatabaseConverter.dart';
import 'package:xplain/models/question.dart';

class QDatabaseHelper {
  
  static final _databaseName = "MyQuestionDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'myquestions';
  
  static final columnId = '_id';
  static final columnQuestion = 'question';
  static final columnIndex = 'myindex';
  static final columnExplainYes = 'myyes';
  static final columnExplainNo = 'myno';

  // make this a singleton class
  QDatabaseHelper._privateConstructor();
  static final QDatabaseHelper instance = QDatabaseHelper._privateConstructor();

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
            $columnQuestion TEXT NOT NULL,
            $columnIndex INTEGER NOT NULL,
            $columnExplainYes TEXT NOT NULL,
            $columnExplainNo TEXT NOT NULL
          )
          ''');
  }
  
  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Question question) async {
    Database db = await instance.database;
    return await db.insert(table, QuestionDatabaseConverter.convertQuestionToDB(question));
  }

  // All of the rows are returned as a list of maps, where each map is 
  // a key-value list of columns.
  Future<List<Question>> queryAllRows() async {
    Database db = await instance.database;
    return (await db.query(table,orderBy: "$columnIndex ASC")).map((e) => QuestionDatabaseConverter.convertDBtoQuestion(e)).toList();
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other 
  // column values will be used to update the row.
  Future<int> update(Question question) async {
    Database db = await instance.database;
    int id =question.dbID;
    return await db.update(table, QuestionDatabaseConverter.convertQuestionToDB(question), where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is 
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(Question question) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [question.dbID]);
  }
}