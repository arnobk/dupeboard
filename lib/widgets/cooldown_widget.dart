import 'package:flutter/material.dart';
import '../utils/database.dart';

class CooldownWidget extends StatefulWidget {
  @override
  _CooldownWidgetState createState() => _CooldownWidgetState();
}

class _CooldownWidgetState extends State<CooldownWidget> {
  List<dynamic> dupeCountdown = [];
  @override
  void initState() {
    super.initState();
    _getDupeCoolDown();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'DupeCooldown',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Sales Cooldown Time For Last 30 Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          dupeCountdown.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  itemCount: dupeCountdown.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 12,
                            child: Stack(
                              children: <Widget>[
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[900],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  constraints: BoxConstraints(minWidth: 20),
                                  child: FractionallySizedBox(
                                    widthFactor: dupeCountdown[index] /
                                        (30 * 3600 * 1000),
                                    child: Container(
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              _getRemainingTime(dupeCountdown[index]),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'You haven\'t sold any cars in last 30 hours!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _getDupeCoolDown() {
    DBProvider.db.getCooldownTime().then((value) {
      setState(() {
        value = value.reversed.toList();
        for (int i = 0; i < value.length; i++) {
          dupeCountdown.add(30 * 3600 * 1000 -
              (DateTime.now().millisecondsSinceEpoch - value[i]));
        }
      });
    });
  }

  String _getRemainingTime(int timeLeft) {
    int hour = timeLeft ~/ (3600 * 1000);
    int min = (timeLeft - hour * 3600 * 1000) ~/ (1000 * 60);
    return hour != 0 ? '$hour\h$min\m' : '$min\m';
  }
}
