import 'package:dupeboard/utils/dupe_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool nForCountFive;
  bool nForCountSix;
  String currentAppVersion = '';
  @override
  void initState() {
    super.initState();
    nForCountFive = true;
    nForCountSix = true;
    _getCurrentVersion();
    _getPrefValues();
  }

  _getPrefValues() async {
    nForCountFive = await _getNotificationPref('nFive');
    nForCountSix = await _getNotificationPref('nSix');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 104, bottom: 84, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Backup/Restore',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.backup),
              title: Text(
                'Backup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Create a backup for your database',
                style: TextStyle(fontSize: 15),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: _createBackup,
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.restore),
              title: Text(
                'Restore',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Restore backup database from storage',
                style: TextStyle(fontSize: 15),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: _restoreBackup,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Sale count reaches 6',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'In last 30 hours',
                style: TextStyle(fontSize: 15),
              ),
              trailing: Switch(
                  value: nForCountSix,
                  onChanged: (value) {
                    _setNotificationPref('nSix', 6, value);
                    setState(() {
                      nForCountSix = value;
                    });
                  }),
              selected: true,
            ),
            ListTile(
              dense: true,
              title: Text(
                'Sale count reaches 5',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'In last 30 hours',
                style: TextStyle(fontSize: 15),
              ),
              trailing: Switch(
                  value: nForCountFive,
                  onChanged: (value) {
                    _setNotificationPref('nFive', 5, value);
                    setState(() {
                      nForCountFive = value;
                    });
                  }),
              selected: true,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Updates',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Check for updates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              subtitle: Text(
                'Current Version: $currentAppVersion',
                style: TextStyle(fontSize: 15),
              ),
              onTap: _checkUpdate,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Developer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: () {
                Navigator.pushNamed(context, '/developer');
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'Github Repository',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: () => _launchURL('https://github.com/arnobk/dupeboard'),
            ),
          ],
        ),
      ),
    );
  }

  _createBackup() async {
    if (await DupeUtils.services.checkStoragePermission(context)) {
      bool backup = await DupeUtils.services.createBackup();
      if (backup) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                  'Backup Successful. Find Backup files at Dupeboard folder of your Internal Storage.'),
              duration: Duration(seconds: 4),
            ),
          );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup Failed!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  _restoreBackup() async {
    if (await DupeUtils.services.checkStoragePermission(context)) {
      bool restore = await DupeUtils.services.restoreBackup();
      if (restore) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Backup restored successfully.'),
              duration: Duration(seconds: 2),
            ),
          );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore Failed!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  _checkUpdate() async {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Checking for updates.'),
          duration: Duration(seconds: 2),
        ),
      );
    var version = await DupeUtils.services.checkForUpdates();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (version != packageInfo.version && version != 'N/A') {
      showDialog(
          context: context,
          builder: (BuildContext cntx) {
            return AlertDialog(
              title: new Text("Update Available!"),
              content: new Text(
                  "There is a new version of this app is available to download."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Update"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _launchURL(
                        'https://github.com/arnobk/dupeboard/releases/tag/$version');
                  },
                ),
              ],
            );
          });
    } else {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('No update available!'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  _getCurrentVersion() async {
    var packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentAppVersion = packageInfo.version;
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _setNotificationPref(String notificationId, int id, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(notificationId, value);
    DupeUtils.services.cancelScheduledNotification(id);
  }

  _getNotificationPref(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationId) != null
        ? prefs.getBool(notificationId)
        : true;
  }
}
