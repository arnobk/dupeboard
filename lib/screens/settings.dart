import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_state_notifier.dart';
import '../utils/dupe_utils.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notifyTwo;
  bool notifyOne;
  bool isAutoUpdateCheck;
  String currentAppVersion = '';
  @override
  void initState() {
    super.initState();
    notifyTwo = true;
    notifyOne = true;
    isAutoUpdateCheck = true;
    _getCurrentVersion();
    _getPrefValues();
  }

  _getPrefValues() async {
    notifyTwo = await _getNotificationPref('notifyTwo');
    notifyOne = await _getNotificationPref('notifyOne');
    isAutoUpdateCheck = await _getUpdatePref('isAutoUpdateCheck');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 16, bottom: 84, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Backup/Restore',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.backup,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Backup',
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                'Create a backup of your database',
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              //selected: true,
              onTap: _createBackup,
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.restore,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Restore',
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                'Restore backup database from storage',
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              onTap: _restoreBackup,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Customization',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  DropdownButton<String>(
                    elevation: 1,
                    value: Provider.of<AppStateNotifier>(context).themeMode,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    iconEnabledColor: Theme.of(context).accentColor,
                    underline: Container(
                      height: 1.5,
                      color: Theme.of(context).accentColor,
                    ),
                    style: Theme.of(context).textTheme.headline4,
                    onChanged: (String newValue) {
                      Provider.of<AppStateNotifier>(context, listen: false)
                          .updateTheme(newValue);
                      // setState(() {
                      //   dropdownValue = newValue;
                      // });
                    },
                    items: <String>[
                      'System Default',
                      'Light Theme',
                      'Dark Theme'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'Custom License Plates',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/CustomPlates');
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              title: Text(
                'Notify when ONE sale slot is available',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Switch(
                  value: notifyOne,
                  onChanged: (value) {
                    _setNotificationPref('notifyOne', 1, value);
                    setState(() {
                      notifyOne = value;
                    });
                  }),
              selected: true,
            ),
            ListTile(
              title: Text(
                'Notify when TWO sale slot is available',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Switch(
                  value: notifyTwo,
                  onChanged: (value) {
                    _setNotificationPref('notifyTwo', 2, value);
                    setState(() {
                      notifyTwo = value;
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
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              title: Text(
                'Automatically check for update on startup',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Switch(
                  value: isAutoUpdateCheck,
                  onChanged: (value) {
                    _setUpdatePref('isAutoUpdateCheck', value);
                    setState(() {
                      isAutoUpdateCheck = value;
                    });
                  }),
              selected: true,
            ),
            ListTile(
              dense: true,
              title: Text(
                'Check for updates',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              subtitle: Text(
                'Current Version: $currentAppVersion',
                style: Theme.of(context).textTheme.headline5,
              ),
              onTap: _checkUpdate,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Others',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                'FAQ',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/faq');
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'Feedback',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/feedback');
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'Donate on Patreon',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              onTap: () {
                _launchURL('https://www.patreon.com/arnobk');
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'Developer',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/developer');
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                'Github Repository',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).accentColor,
              ),
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
              content: Text(
                  'Backup restored successfully. Please relaunch Dupeboard to work properly.'),
              duration: Duration(seconds: 4),
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
              title: new Text("Dupeboard Update Available!"),
              content: new Text(
                  "There is a new version of Dupeboard is available to download. Please make a backup of your database from settings before updating."),
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
    if (!value) {
      DupeUtils.services.cancelScheduledNotification(id);
    } else {
      DupeUtils.services.getNotificationTimeAndScheduleNotification();
    }
  }

  _getNotificationPref(String notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(notificationId) != null
        ? prefs.getBool(notificationId)
        : true;
  }

  _setUpdatePref(String updatePref, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(updatePref, value);
  }

  _getUpdatePref(String updatePref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(updatePref) != null ? prefs.getBool(updatePref) : true;
  }
}
