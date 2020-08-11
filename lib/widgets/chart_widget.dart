import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'utils/database.dart';
import 'dart:math';

class ChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChartWidgetState();
}

class ChartWidgetState extends State<ChartWidget> {
  final Color barBackgroundColor = Colors.transparent;
  final Duration animDuration = const Duration(milliseconds: 250);

  List<double> graphData = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  @override
  void initState() {
    super.initState();
    _getGraphData();
  }

  int touchedIndex;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'DupeChart',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Previous Week Sales',
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.blue[900] : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: graphData.reduce(max) + 1,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, graphData[0], isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, graphData[1], isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, graphData[2], isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, graphData[3], isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, graphData[4], isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, graphData[5], isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, graphData[6], isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    var day = [
      DateTime.now().subtract(Duration(days: 6)).weekday,
      DateTime.now().subtract(Duration(days: 5)).weekday,
      DateTime.now().subtract(Duration(days: 4)).weekday,
      DateTime.now().subtract(Duration(days: 3)).weekday,
      DateTime.now().subtract(Duration(days: 2)).weekday,
      DateTime.now().subtract(Duration(days: 1)).weekday,
      DateTime.now().weekday,
    ];
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;

              switch (group.x.toInt()) {
                case 0:
                  weekDay = _getWeekDay(day[0]);
                  break;
                case 1:
                  weekDay = _getWeekDay(day[1]);
                  break;
                case 2:
                  weekDay = _getWeekDay(day[2]);
                  break;
                case 3:
                  weekDay = _getWeekDay(day[3]);
                  break;
                case 4:
                  weekDay = _getWeekDay(day[4]);
                  break;
                case 5:
                  weekDay = _getWeekDay(day[5]);
                  break;
                case 6:
                  weekDay = _getWeekDay(day[6]);
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.white));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return _getWeekDay(day[0]).substring(0, 1);
              case 1:
                return _getWeekDay(day[1]).substring(0, 1);
              case 2:
                return _getWeekDay(day[2]).substring(0, 1);
              case 3:
                return _getWeekDay(day[3]).substring(0, 1);
              case 4:
                return _getWeekDay(day[4]).substring(0, 1);
              case 5:
                return _getWeekDay(day[5]).substring(0, 1);
              case 6:
                return _getWeekDay(day[6]).substring(0, 1);
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }

  _getGraphData() {
    DBProvider.db.getWeekCount().then((value) {
      setState(() {
        graphData = value;
      });
    });
  }

  String _getWeekDay(int weekday) {
    String day = '';
    switch (weekday) {
      case 1:
        return day = 'Monday';
      case 2:
        return day = 'Tuesday';
      case 3:
        return day = 'Wednesday';
      case 4:
        return day = 'Thursday';
      case 5:
        return day = 'Friday';
      case 6:
        return day = 'Saturday';
      case 7:
        return day = 'Sunday';
    }
    return day;
  }
}
