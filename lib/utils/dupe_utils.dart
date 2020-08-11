import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

class DupeUtils {
  DupeUtils._();
  static final DupeUtils services = DupeUtils._();

  getNotificationTimeAndScheduleNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool notifyTwo =
        prefs.getBool('notifyTwo') != null ? prefs.getBool('notifyTwo') : true;
    bool notifyOne =
        prefs.getBool('notifyOne') != null ? prefs.getBool('notifyOne') : true;

    DBProvider.db.getNotificationTime().then((notificationTimes) {
      int twoHours = 0;
      for (int i = 0; i < notificationTimes.length; i++) {
        if (notificationTimes[i] - DateTime.now().millisecondsSinceEpoch >
            28 * 3600 * 1000) {
          twoHours++;
        }
      }
      //print('twoHours: $twoHours');
      if (notificationTimes.length > 5 && notifyTwo) {
        DateTime scheduleTime =
            DateTime.fromMillisecondsSinceEpoch(notificationTimes[5]).isAfter(
                    DateTime.fromMillisecondsSinceEpoch(notificationTimes[0])
                        .subtract(Duration(hours: 28)))
                ? DateTime.fromMillisecondsSinceEpoch(notificationTimes[5])
                : DateTime.fromMillisecondsSinceEpoch(notificationTimes[0])
                    .subtract(Duration(hours: 28));
        print('notify2 scheduled at $scheduleTime');
        _createScheduledNotification(
          scheduleTime.millisecondsSinceEpoch,
          2,
          'Ready For Back to Back Dupe Sale',
          'Two car sale slot is available now. Go, Grab some \$GTA.',
        );
      } else if (notificationTimes.length <= 5 && twoHours > 0 && notifyTwo) {
        DateTime scheduleTime =
            DateTime.fromMillisecondsSinceEpoch(notificationTimes[0])
                .subtract(Duration(hours: 28));
        print('notify2/2 scheduled at $scheduleTime');
        _createScheduledNotification(
          scheduleTime.millisecondsSinceEpoch,
          2,
          'Ready For Back to Back Dupe Sale',
          'Two car sale slot is available now. Go, Grab some \$GTA.',
        );
      } else {
        cancelScheduledNotification(2);
      }
      if (notificationTimes.length > 6 && notifyOne) {
        DateTime scheduleTime =
            DateTime.fromMillisecondsSinceEpoch(notificationTimes[6]).isAfter(
                    DateTime.fromMillisecondsSinceEpoch(notificationTimes[1])
                        .subtract(Duration(hours: 28)))
                ? DateTime.fromMillisecondsSinceEpoch(notificationTimes[6])
                : DateTime.fromMillisecondsSinceEpoch(notificationTimes[1])
                    .subtract(Duration(hours: 28));
        print('notify1 scheduled at $scheduleTime');
        _createScheduledNotification(
          scheduleTime.millisecondsSinceEpoch,
          1,
          'One car sale slot is available.',
          'You haven\'t sold any car for a while. You can start selling right now.',
        );
      } else if (notificationTimes.length <= 6 && twoHours > 1 && notifyOne) {
        DateTime scheduleTime =
            DateTime.fromMillisecondsSinceEpoch(notificationTimes[1])
                .subtract(Duration(hours: 28));
        print('notify1/1 scheduled at $scheduleTime');
        _createScheduledNotification(
          scheduleTime.millisecondsSinceEpoch,
          1,
          'One car sale slot is available.',
          'You haven\'t sold any car for a while. You can start selling right now.',
        );
      } else {
        cancelScheduledNotification(1);
      }
    });
  }

  _createScheduledNotification(
      int time, int id, String title, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid;
    var initializationSettingsIOS;
    var initializationSettings;
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    FlutterLocalNotificationsPlugin().initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'GENERAL',
      'Dupe Notifications',
      'This channel will provide notification when you are below your sale limit and you can do dupe sale again.',
      importance: Importance.High,
      priority: Priority.High,
      enableVibration: true,
      playSound: true,
      color: Colors.blue,
      channelShowBadge: true,
      styleInformation: BigTextStyleInformation(''),
      ticker: 'Dupe Notifications',
    );
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        title,
        body,
        DateTime.fromMillisecondsSinceEpoch(time),
        //DateTime.now().add(Duration(seconds: 10)),
        platformChannelSpecifics);
  }

  Future _onSelectNotification(String payload) async {
    //
  }
  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    //
  }

  cancelScheduledNotification(int id) {
    FlutterLocalNotificationsPlugin().cancel(id);
    print('canceled notify$id');
  }

  Future<bool> checkStoragePermission(BuildContext context) async {
    bool permission = false;
    var status = await Permission.storage.status;
    if (status.isUndetermined || status == PermissionStatus.denied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] == PermissionStatus.granted)
        permission = true;
      else if (statuses[Permission.storage] == PermissionStatus.denied) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission Denied!'),
          ),
        );
      }
    } else if (status == PermissionStatus.permanentlyDenied) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please allow STORAGE permission from device settings.'),
        ),
      );
    } else {
      permission = true;
    }

    return permission;
  }

  Future<bool> createBackup() async {
    bool status = false;
    final databasePath = await getDatabasesPath();
    final sourcePath = join(databasePath, 'dupeboard.db');
    File sourceFile = File(sourcePath);
    List content = await sourceFile.readAsBytes();

    final targetDir = await getExternalStorageDirectory();
    final rootDir = targetDir.path.startsWith('/storage/emulated')
        ? targetDir.path.substring(1, 19)
        : targetDir.path.substring(1, 18);

    final now = DateTime.now();
    String fileSuffix = DateFormat("yMMddHHmm").format(now);
    await new Directory('$rootDir/Dupeboard').create(recursive: true);
    final targetPath =
        join('$rootDir/Dupeboard', 'BACKUP_$fileSuffix.dupeboard.bin');
    File targetFile = File(targetPath);
    await targetFile.writeAsBytes(content, flush: true).then((value) {
      status = value.path.isNotEmpty;
    });
    return status;
  }

  restoreBackup() async {
    bool status = false;
    File backupFile = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['bin']);
    if (backupFile != null) {
      File sourceFile = File(backupFile.path);
      List content = await sourceFile.readAsBytes();

      final targetDir = await getDatabasesPath();
      final targetPath = join(targetDir, 'dupeboard.db');
      File targetFile = File(targetPath);
      await targetFile.writeAsBytes(content, flush: true).then((value) {
        status = value.path.isNotEmpty;
      });
    }

    return status;
  }

  checkForUpdates() async {
    var githubAPI = 'https://api.github.com/repos/arnobk/dupeboard/releases';

    var releaseInfo = await http.get(githubAPI);
    if (releaseInfo.statusCode == 200) {
      if (json.decode(releaseInfo.body).toString() != '[]') {
        return json.decode(releaseInfo.body)[0]['tag_name'];
      } else {
        return 'N/A'; // No Release Found
      }
    } else {
      throw Exception('Unable to check for updates.');
    }
  }
}
