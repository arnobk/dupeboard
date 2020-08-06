import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './utils/database.dart';

class DupeList extends StatefulWidget {
  @override
  _DupeListState createState() => _DupeListState();
}

class _DupeListState extends State<DupeList> {
  var dupeData = [];
  @override
  void initState() {
    super.initState();
    _getDupeData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 84, bottom: 64),
      itemCount: dupeData.length,
      itemBuilder: (context, index) {
        //return Text(dupeData.data[index]['id'].toString());
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: ListTile(
            //onTap: () {},
            leading: Container(
              height: double.infinity,
              child: Icon(
                Icons.calendar_today,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(dupeData[index]['date'])),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            subtitle: Text(
              dupeData[index]['time'].toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 28,
                color: Colors.red[800],
              ),
              onPressed: () => _showDialog(context, dupeData[index]['id']),
            ),
          ),
        );
      },
    );
  }

  _showDialog(BuildContext cntx, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Dupe?"),
          content:
              new Text("This will delete the dupe from your database forever."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _removeDupe(id);
                Scaffold.of(cntx)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Dupe Deleted'),
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }

  _getDupeData() {
    DBProvider.db.getDupe().then((value) {
      setState(() {
        dupeData = value;
      });
    });
  }

  _removeDupe(int id) {
    DBProvider.db.removeDupe(id).then((value) {
      _getDupeData();
    });
  }
}
