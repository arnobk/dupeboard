import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../models/dupe.dart';
import '../models/plate.dart';

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
      onConfigure: onConfigure,
      onCreate: (db, version) async {
        var batch = db.batch();
        _createTableDupesV2(batch);
        _createTablePlateV2(batch);
        await batch.commit();
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          _updateTableDupesV1toV2(batch);
          _createTablePlateV2(batch);
        }
        await batch.commit();
      },
      version: 2,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  /// Let's use FOREIGN KEY constraints
  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create Dupes table V2
  void _createTableDupesV2(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS dupes');
    batch.execute('''CREATE TABLE dupes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          time TEXT,
          plate TEXT,
          timestamp INTEGER
        )''');
  }

  /// Update Dupes table V1 to V2
  void _updateTableDupesV1toV2(Batch batch) {
    batch.execute('ALTER TABLE dupes ADD plate TEXT');
  }

  /// Create License Plate table V2
  void _createTablePlateV2(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS plates');
    batch.execute('''CREATE TABLE plates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        license TEXT
      )''');
  }

  newDupe(Dupe dupe) async {
    final db = await getDb();
    var res = await db.rawInsert(
        "INSERT INTO dupes (date, time, timestamp,plate) VALUES(?,?,?,?)",
        [dupe.date, dupe.time, dupe.timestamp, dupe.plate]);
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

  newPlate(Plate plate) async {
    final db = await getDb();
    var res = await db
        .rawInsert("INSERT INTO plates (license) VALUES(?)", [plate.license]);
    return res;
  }

  Future<dynamic> getPlate() async {
    final db = await getDb();
    List<Map<String, dynamic>> dupes =
        await db.rawQuery('SELECT * FROM plates');
    return dupes;
  }

  removePlate(int id) async {
    final db = await getDb();
    await db.rawQuery('DELETE FROM plates WHERE id=$id');
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
            'SELECT * from dupes WHERE timestamp > ${DateTime.now().subtract(Duration(hours: 30)).millisecondsSinceEpoch} ORDER BY timestamp DESC')
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        notificationTime.add(
            DateTime.fromMillisecondsSinceEpoch(value[i]['timestamp'])
                .add(Duration(hours: 30))
                .millisecondsSinceEpoch);
      }
      notificationTime.sort();
      notificationTime = notificationTime.reversed.toList();
      // for (int i = 0; i < notificationTime.length; i++) {
      //   print(DateTime.fromMillisecondsSinceEpoch(notificationTime[i]));
      // }
    });
    return notificationTime;
  }

  Future<List<int>> getCooldownTime() async {
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
