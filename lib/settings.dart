import 'package:dupeboard/utils/dupe_utils.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool nForCountFive;
  bool nForCountSix;
  @override
  void initState() {
    super.initState();
    nForCountFive = true;
    nForCountSix = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 104, bottom: 64),
        margin: EdgeInsets.symmetric(horizontal: 20),
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
                ),
              ),
              subtitle: Text(
                'Create a backup for your database',
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
                ),
              ),
              subtitle: Text(
                'Restore backup database from storage',
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: _restoreBackup,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 16),
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         flex: 1,
            //         child: ButtonTheme(
            //           shape: RoundedRectangleBorder(
            //               side: BorderSide(
            //                   color: Theme.of(context).primaryColor, width: 1),
            //               borderRadius: BorderRadius.circular(5)),
            //           child: RaisedButton(
            //             elevation: 0,
            //             focusElevation: 0,
            //             highlightElevation: 0,
            //             hoverElevation: 0,
            //             disabledElevation: 0,
            //             color: Colors.white,
            //             onPressed: _createBackup,
            //             child: Container(
            //               padding: EdgeInsets.symmetric(vertical: 20),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: <Widget>[
            //                   Icon(
            //                     Icons.backup,
            //                     size: 28,
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                   SizedBox(
            //                     width: 8,
            //                   ),
            //                   Text(
            //                     'Backup',
            //                     style: TextStyle(
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.w500,
            //                       color: Theme.of(context).primaryColor,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         width: 16,
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: ButtonTheme(
            //           shape: RoundedRectangleBorder(
            //               side: BorderSide(
            //                   color: Theme.of(context).primaryColor, width: 1),
            //               borderRadius: BorderRadius.circular(5)),
            //           child: RaisedButton(
            //             elevation: 0,
            //             focusElevation: 0,
            //             highlightElevation: 0,
            //             hoverElevation: 0,
            //             disabledElevation: 0,
            //             color: Colors.white,
            //             onPressed: _restoreBackup,
            //             child: Container(
            //               padding: EdgeInsets.symmetric(vertical: 20),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: <Widget>[
            //                   Icon(
            //                     Icons.restore,
            //                     size: 28,
            //                     color: Theme.of(context).primaryColor,
            //                   ),
            //                   SizedBox(
            //                     width: 8,
            //                   ),
            //                   Text(
            //                     'Restore',
            //                     style: TextStyle(
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.w500,
            //                       color: Theme.of(context).primaryColor,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
                ),
              ),
              subtitle: Text(
                'In last 30 hours',
              ),
              trailing: Switch(
                  value: nForCountSix,
                  onChanged: (value) {
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
                ),
              ),
              subtitle: Text(
                'In last 30 hours',
              ),
              trailing: Switch(
                  value: nForCountFive,
                  onChanged: (value) {
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
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              subtitle: Text('Current Version: 1.0.0'),
              onTap: () {},
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
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: () {},
            ),
            ListTile(
              dense: true,
              title: Text(
                'Github Repository',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              selected: true,
              onTap: () {},
            ),
          ],
        ));
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
            ),
          );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup Failed!'),
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
            ),
          );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore Failed!'),
          ),
        );
      }
    }
  }
}
