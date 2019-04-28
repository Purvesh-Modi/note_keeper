import 'dart:async';
import 'dart:io';

import 'package:note_keeper/models/Note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static DataBaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colCreatedOn = 'createdOn';

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable ('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT,'
        '$colDescription TEXT,'
        '$colPriority INTEGER,'
        '$colCreatedOn TEXT)');
  }

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  //get all the notes
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority DESC');
    return result;
  }

  //insert note
  Future<int> insetNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //update note
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete operation
  Future<int> deleteNote(Note note) async {
    Database db = await this.database;
    var result =
        await db.delete(noteTable, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //get number of note objects from DB
  Future<int> getCount() async {
    Database db = await this.database;
    int result = Sqflite.firstIntValue(await db.query(noteTable));
    return result;
  }

  //get note list
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();

    List<Note> noteList = List();
    noteMapList.forEach((noteMapObject) {
      noteList.add(Note.fromMapObject(noteMapObject));
    });
    return noteList;
  }
}
