class Dupe {
  int id;
  String date;
  String time;
  int timestamp;
  Dupe({this.id, this.date, this.time, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'timestamp': timestamp,
    };
  }

  Dupe.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    time = map['time'];
    timestamp = map['timestamp'];
  }
}
