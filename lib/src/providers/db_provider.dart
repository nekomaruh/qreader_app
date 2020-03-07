import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qreader_app/src/models/scan_model.dart';
export 'package:qreader_app/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE scans('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')');
    });
  }

  newScanRaw(ScanModel newScan) async {
    final db = await database;
    final res = await db.rawInsert("INSERT INTO scans (id, type, value) "
        "VALUES (${newScan.id},'${newScan.type}','${newScan.value}')");
    return res;
  }

  newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db.insert('scans', newScan.toJson());
    return res;
  }

  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('scans');
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getAllScansByType(String type) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM SCANS WHERE type = '$type'");
    List<ScanModel> list =
    res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  // Update registers
  Future<int> updateScans(ScanModel newScan) async{
    final db = await database;
    final res = await db.update('scans', newScan.toJson(), where: "id = ?",  whereArgs: [newScan.id]);
    return res;
  }

  // Delete register
  Future<int> deleteScan(int id) async{
    final db =  await database;
    final res = await db.delete('scans', where: "id = ?", whereArgs: [id]);
    return res;
  }

  // Delete register
  Future<int> deleteAll() async{
    final db =  await database;
    final res = await db.rawDelete(
        "DELETE FROM scans");
    return res;
  }

}
