import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  // this.time,
  // this.isChecked,
  // this.image,
  // this.name,
  // this.subject,
  // this.body,
  // this.isAttachmentAvailable,
  // this.tagColor,
  // this.from_email

  static const _dbName = 'myDatabase.db';
  static const _dbVersion = 1;
  static const _tableName = 'Emails';
  static const columnId='ID';
  static const columnIsChecked='IsChecked';
  static const columnTime='Time';
  static const columnImage='Image';
  static const columnName='Name';
  static const columnSubject='Subject';
  static const columnBody='Body';
  static const columnIsAttachmentAvailable='IsAttachmentAvailable';
  static const columnTagColor='TagColor';
  static const columnFromEmail='FromEmail';

  //make it a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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
      $columnIsChecked BOOL,
      $columnTime TEXT,
      $columnImage TEXT,
      $columnSubject TEXT,
      $columnBody TEXT,
      $columnIsAttachmentAvailable BOOL,
      $columnTagColor TEXT,
      $columnFromEmail TEXT
       )
      '''
    );
  }

  Future<int> insert(Map<String,dynamic> row) async{
    Database db = await instance.database;
    return (await db?.insert(_tableName, row));
  }

  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db = await instance.database;
    return (await db?.query(_tableName));
  }

  Future<int> delete() async{
    Database db = await instance.database;
    return await db?.delete(_tableName);  //,where: '$columnId=?',whereArgs: [id]
  }

}