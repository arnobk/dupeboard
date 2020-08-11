import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/database.dart';
import '../models/plate.dart';

class CustomPlateScreen extends StatefulWidget {
  @override
  _CustomPlateScreenState createState() => _CustomPlateScreenState();
}

class _CustomPlateScreenState extends State<CustomPlateScreen> {
  TextEditingController _addLicenseTextController = new TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var customPlates = [];

  @override
  void initState() {
    super.initState();
    _getCustomPlates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Custom License Plates',
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        brightness: Theme.of(context).appBarTheme.brightness,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddPlateDialog(),
        label: Text('Add Plate'),
        icon: Icon(Icons.add),
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Theme.of(context).accentColor,
          onRefresh: _refreshScreen,
          child: ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 84),
              itemCount: customPlates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.confirmation_number,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(customPlates[index]['license'],
                      style: Theme.of(context).textTheme.headline4),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () =>
                        _deleteConfirmation(context, customPlates[index]['id']),
                  ),
                );
              }),
        ),
      ),
    );
  }

  _deletePlate(int id) {
    DBProvider.db.removePlate(id).then((value) {
      _getCustomPlates();
    });
  }

  Future<void> _refreshScreen() async {
    _getCustomPlates();
  }

  _openAddPlateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add License Plate"),
          content: TextField(
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            controller: _addLicenseTextController,
            style: Theme.of(context).textTheme.headline5,
            decoration: InputDecoration(
              hintText: 'License Plate',
              hintStyle: Theme.of(context).textTheme.caption,
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                _addLicenseTextController.text = '';
              },
            ),
            new FlatButton(
              child: new Text("Add"),
              onPressed: _addToDatabase,
            ),
          ],
        );
      },
    );
  }

  _deleteConfirmation(BuildContext cntx, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete Plate?"),
          content: new Text(
              "This will delete the plate from your database forever."),
          actions: <Widget>[
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
                _deletePlate(id);
                Scaffold.of(cntx)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('License Plate Deleted'),
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }

  _addToDatabase() {
    if (_addLicenseTextController.text.isEmpty) {
      Navigator.pop(context, "License plate is empty!");
      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('License plate is empty!'),
            duration: Duration(seconds: 2),
          ),
        );
    } else {
      var plate = Plate(license: _addLicenseTextController.text.toUpperCase());
      DBProvider.db.newPlate(plate);
      Navigator.pop(context, "License plate added!");
      _addLicenseTextController.text = '';
      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('License Plate Added!'),
            duration: Duration(seconds: 2),
          ),
        );
    }
  }

  _getCustomPlates() async {
    DBProvider.db.getPlate().then((value) {
      setState(() {
        customPlates = value;
      });
    });
  }
}
