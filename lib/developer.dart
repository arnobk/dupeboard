import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Dupeboard',
          style: TextStyle(color: Colors.black),
        ),
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: Color(0xF4FFFFFF),
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
