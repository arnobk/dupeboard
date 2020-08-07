import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'home_widget.dart';
import 'developer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dupe Timer',
      theme: ThemeData(
        canvasColor: Color(0xFFFFFFFF),
        appBarTheme: AppBarTheme(
          color: Color(0xFFFFFFFF),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoPageRoute(
                builder: (_) => Home(), settings: settings);
          case '/developer':
            return CupertinoPageRoute(
                builder: (_) => DeveloperScreen(), settings: settings);
          default:
            return CupertinoPageRoute(
                builder: (_) => Home(), settings: settings);
        }
      },
    );
  }
}
