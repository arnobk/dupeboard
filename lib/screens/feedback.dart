import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final CollectionReference collectionReference =
      Firestore.instance.collection('feedback');

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _feedbackFormKey = GlobalKey<FormState>();
  TextEditingController _feedbackName = new TextEditingController();
  TextEditingController _feedbackEmail = new TextEditingController();
  TextEditingController _feedbackMessage = new TextEditingController();
  String _feedbackTopic;
  String _appVersion;
  String _buildNumber;

  _sendFeedback() {
    collectionReference.add({
      'full_name': _feedbackName.text,
      'email': _feedbackEmail.text,
      'topic': _feedbackTopic,
      'message': _feedbackMessage.text,
      'app_version': _appVersion,
      'build_number': _buildNumber,
      'time': DateTime.now(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    setState(() {
      _feedbackName.text = '';
      _feedbackEmail.text = '';
      _feedbackTopic = null;
      _feedbackMessage.text = '';
    });
    scaffoldKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Feedback sent!'),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _buildNumber = packageInfo.buildNumber;
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _feedbackFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _feedbackName,
                    validator: (value) =>
                        value.isEmpty ? 'Please enter your name' : null,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      hintText: 'Your Name',
                      hintStyle: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  TextFormField(
                    validator: (value) =>
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)
                            ? 'Please enter a valid email'
                            : null,
                    controller: _feedbackEmail,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'Please select a topic' : null,
                    isExpanded: true,
                    elevation: 1,
                    value: _feedbackTopic,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    iconEnabledColor: Theme.of(context).accentColor,
                    hint: Text(
                      'Choose a topic',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    style: Theme.of(context).textTheme.headline5,
                    onChanged: (String newValue) {
                      setState(() {
                        _feedbackTopic = newValue;
                      });
                    },
                    items: <String>[
                      'Support',
                      'Bug Report',
                      'Feature Request',
                      'App Review',
                      'Others'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    controller: _feedbackMessage,
                    validator: (value) => value.length < 100
                        ? 'Your message must be atleast 100 characters.'
                        : null,
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 15,
                    minLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: () {
                          if (_feedbackFormKey.currentState.validate()) {
                            _sendFeedback();
                          }
                        },
                        child: Text(
                          'SEND FEEDBACK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
