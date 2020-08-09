import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './utils/database.dart';
import './models/dupe.dart';

class AddDupe extends StatefulWidget {
  AddDupe();
  @override
  _AddDupeState createState() => _AddDupeState();
}

class _AddDupeState extends State<AddDupe> {
  DateTime pickedDate;
  TimeOfDay pickedTime;
  var customPlates = [''];
  String selectedPlate = '';
  @override
  void initState() {
    super.initState();
    _getCustomPlates();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTile(
              leading: Text(
                'License Plate:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              title: DropdownButton<String>(
                isExpanded: true,
                elevation: 1,
                value: selectedPlate,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                iconEnabledColor: Theme.of(context).accentColor,
                underline: Container(
                  height: 1.5,
                  color: Theme.of(context).accentColor,
                ),
                style: Theme.of(context).textTheme.headline4,
                onChanged: (String newValue) {
                  setState(() {
                    selectedPlate = newValue;
                  });
                },
                items:
                    customPlates.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                DateFormat('yyyy-MM-dd').format(pickedDate),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: InkWell(
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
            ),
            ListTile(
              leading: Icon(
                Icons.access_time,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                "${pickedTime.format(context)}",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              trailing: InkWell(
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
            ),
            Expanded(
              child: SizedBox(
                height: 10,
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 48,
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: _addToDatabase,
                    child: Text(
                      'ADD DUPE',
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
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  _addToDatabase() {
    var newDupe = Dupe(
      date: pickedDate.toString(),
      time: pickedTime.format(context),
      plate: selectedPlate,
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
                  dialogBackgroundColor: Theme.of(context).primaryColor,
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
                  colorScheme: ColorScheme.dark(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    surface: Theme.of(context).primaryColor,
                    onSurface: Colors.white,
                  ),
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

  _getCustomPlates() async {
    DBProvider.db.getPlate().then((value) {
      setState(() {
        for (int i = 0; i < value.length; i++) {
          customPlates.add(value[i]['license']);
        }
      });
    });
  }
}
