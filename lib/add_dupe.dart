import 'package:flutter/material.dart';
import './utils/database.dart';
import 'package:intl/intl.dart';
import './models/dupe.dart';

class AddDupe extends StatefulWidget {
  AddDupe();
  @override
  _AddDupeState createState() => _AddDupeState();
}

class _AddDupeState extends State<AddDupe> {
  DateTime pickedDate;
  TimeOfDay pickedTime;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            elevation: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(pickedDate),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _pickDate,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "${pickedTime.format(context)}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _pickTime,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 10,
            ),
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: _addToDatabase,
                  child: Text('Add Dupe'),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  _addToDatabase() {
    var newDupe = Dupe(
      date: pickedDate.toString(),
      time: pickedTime.format(context),
      timestamp: DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ).millisecondsSinceEpoch,
    );
    DBProvider.db.newDupe(newDupe);
    Navigator.pop(context, "New Dupe Added!");
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      helpText: 'SELECT SALE DATE',
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).appBarTheme.brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    surface: Theme.of(context).primaryColor,
                    onSurface: Colors.white,
                  ),
                  dialogBackgroundColor: Theme.of(context).canvasColor,
                )
              : ThemeData.light(),
          child: child,
        );
      },
    );

    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  _pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).appBarTheme.brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  backgroundColor: Theme.of(context).primaryColor,
                  dialogBackgroundColor: Theme.of(context).canvasColor,
                )
              : ThemeData.light(),
          child: child,
        );
      },
    );
    if (time != null) {
      setState(() {
        pickedTime = time;
      });
    }
  }
}
