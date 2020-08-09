import 'package:flutter/material.dart';
import 'add_dupe.dart';
import 'dupe_list.dart';
import 'dupeboard.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  DateTime currentBackPressTime;
  int _currentIndex = 0;
  List<Widget> _children = [
    Dupeboard(),
    DupeList(),
    Settings(),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Dupeboard',
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          brightness: Theme.of(context).appBarTheme.brightness,
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.color,
          elevation: 0,
        ),
        body: SafeArea(
          child: _children[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).canvasColor,
          unselectedItemColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).accentColor,
          elevation: 8.0,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Transform.rotate(
                angle: 90 * 3.14159 / 180,
                child: Icon(
                  Icons.whatshot,
                ),
              ),
              title: new Text('Dupeboard'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.history),
              title: new Text('History'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddDupeSheet(),
          label: Text('Add Dupe'),
          icon: Icon(Icons.add),
          elevation: 2,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _showAddDupeSheet() async {
    final result = await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: AddDupe(),
          );
        });
    if (result != null) {
      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("$result"),
          duration: Duration(seconds: 2),
        ));
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Press back button again to exit Dupeboard.'),
          duration: Duration(seconds: 2),
        ));
      return Future.value(false);
    }
    return Future.value(true);
  }
}
