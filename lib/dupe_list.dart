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
      padding: EdgeInsets.only(top: 0, bottom: 64),
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
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            title: Text(
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(dupeData[index]['date'])),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text(
              dupeData[index]['time'].toString(),
              style: Theme.of(context).textTheme.bodyText2,
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
