import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import '../models/dupe.dart';
import 'dart:async';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> getDb() async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<dynamic> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'dupeboard.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE dupes (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, time TEXT, timestamp INTEGER)');
      },
      version: 1,
    );
  }

  newDupe(Dupe dupe) async {
    final db = await getDb();
    var res = await db.rawInsert(
        "INSERT INTO dupes (date, time, timestamp) VALUES(?,?,?)",
        [dupe.date, dupe.time, dupe.timestamp]);
    return res;
  }

  Future<dynamic> getDupe() async {
    final db = await getDb();
    List<Map<String, dynamic>> dupes =
        await db.rawQuery('SELECT * FROM dupes ORDER BY timestamp DESC');
    return dupes;
  }

  removeDupe(int id) async {
    final db = await getDb();
    await db.rawQuery('DELETE FROM dupes WHERE id=$id');
  }

  Future<int> getCount(int minute) async {
    final db = await getDb();
    var count = await db.rawQuery(
        'SELECT * from dupes WHERE timestamp > ${DateTime.now().millisecondsSinceEpoch - minute * 60000}');
    return count.length;
  }

  Future<List> getWeekCount() async {
    final db = await getDb();
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    List<DateTime> weekdays = [
      date.subtract(Duration(days: 6)),
      date.subtract(Duration(days: 5)),
      date.subtract(Duration(days: 4)),
      date.subtract(Duration(days: 3)),
      date.subtract(Duration(days: 2)),
      date.subtract(Duration(days: 1)),
      date,
      date.add(Duration(days: 1))
    ];
    List<double> count = [];
    for (int i = 0; i < 7; i++) {
      var query = await db.rawQuery(
          'SELECT * from dupes WHERE timestamp >= ${weekdays[i].millisecondsSinceEpoch}  AND timestamp < ${weekdays[i + 1].millisecondsSinceEpoch}');
      count.add(query.length.toDouble());
    }
    return count;
  }

  Future<List<int>> getNotificationTime() async {
    final db = await getDb();
    List<int> notificationTime = [];
    await db
        .rawQuery(
            'SELECT * from dupes WHERE timestamp > ${DateTime.now().millisecondsSinceEpoch - 30 * 60 * 60000} ORDER BY timestamp DESC')
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        notificationTime.add(value[i]['timestamp']);
      }
    });
    return notificationTime;
  }
}
