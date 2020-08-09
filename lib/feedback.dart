import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatelessWidget {
  final CollectionReference collectionReference =
      Firestore.instance.collection('feedback');

  _addData() {
    collectionReference.add({
      'full_name': 'Arnob Karmokar',
      'email': 'aaarnobk@gmail.com',
      'message': 'this is a test message',
      'time': DateTime.now(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Feedback',
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        brightness: Theme.of(context).appBarTheme.brightness,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: RaisedButton(
            onPressed: _addData,
            child: Text('Add Feedback'),
          ),
        ),
      ),
    );
  }
}
