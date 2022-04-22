import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseUserHelper{

  static const _dbName = 'UserDatabase.db';
  static const _dbVersion = 2;
  static const _tableName = 'UsersTable';
  static const columnId='ID';
  static const columnImage='Image';
  static const columnName='Name';
  static const columnEmail='Email';
  static const columnToken='Token';

  //make it a singleton class
  DatabaseUserHelper._privateConstructor();
  static final DatabaseUserHelper instance = DatabaseUserHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async{
    if(_database!=null) {
      return _database;
    }
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,_dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);

  }

  Future _onCreate(Database db,int version){


    return db.execute(
        '''
      CREATE TABLE $_tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT,
      $columnImage TEXT,
      $columnToken TEXT,
      $columnEmail TEXT
       )
      '''
    );

  }

  Future<int> insertUser(Map<String,dynamic> row) async{
    Database db = await instance.database;
    return (await db?.insert(_tableName, row));
  }

  Future<List<Map<String,dynamic>>> queryAllUser() async{
    Database db = await instance.database;
    return (await db?.query(_tableName));
  }

  Future<int> delete() async{
    Database db = await instance.database;
    return await db?.delete(_tableName);  //,where: '$columnId=?',whereArgs: [id]
  }

}