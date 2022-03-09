import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/day_tracker/mood.dart';
import 'package:mental_health/mh_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrackerChart extends StatefulWidget {
  const TrackerChart({Key? key}) : super(key: key);

  @override
  _TrackerChartState createState() => _TrackerChartState();
}

class _TrackerChartState extends State<TrackerChart> {
  final moods = [
    Mood(3, DateTime.utc(2022, 1, 1)),
    Mood(3, DateTime.utc(2022, 1, 2)),
    Mood(3, DateTime.utc(2022, 1, 3)),
    Mood(3, DateTime.utc(2022, 1, 4)),
    Mood(3, DateTime.utc(2022, 1, 5)),
    Mood(5, DateTime.now()),
    Mood(10, DateTime.utc(2022, 4, 5)),
    Mood(1, DateTime.utc(2022, 5, 5)),
  ];

  late DateTime today;

  @override
  void initState() {
    today = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Mood Tracker"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enableSelectionZooming: true,
                  enableMouseWheelZooming: true,
                  enablePanning: true,
                  zoomMode: ZoomMode.x,
                ),
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  intervalType: DateTimeIntervalType.days,
                  visibleMinimum: DateTime(
                      today.year, today.month, today.day - today.weekday % 7),
                  visibleMaximum: DateTime(
                      today.year, today.month, today.day + today.weekday % 7),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 10,
                  interval: 1,
                ),
                series: <ChartSeries>[
                  ColumnSeries<Mood, DateTime>(
                    dataSource: moods,
                    xValueMapper: (Mood data, _) => data.when,
                    yValueMapper: (Mood data, _) => data.level,
                    width: .85,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: MHColors.trackerLineColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
