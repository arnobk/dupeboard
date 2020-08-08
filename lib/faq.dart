import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'FAQ',
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        brightness: Theme.of(context).appBarTheme.brightness,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomExpansionTile('What is Dupeboard?',
                  'Dupeboard is a simple app for tracking GTA car selling which is very usefule for duper.'),
              CustomExpansionTile('What is your question?',
                  'Dupeboard is a simple app for tracking GTA car selling which is very usefule for duper.'),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String details;
  CustomExpansionTile(this.title, this.details);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).appBarTheme.brightness == Brightness.dark
          ? ThemeData.dark()
              .copyWith(unselectedWidgetColor: Theme.of(context).accentColor)
          : ThemeData.light(),
      child: ExpansionTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline4,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
            child: Text(details),
          )
        ],
      ),
    );
  }
}
