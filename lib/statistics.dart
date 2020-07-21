import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:scales/model/weight_log.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<WeightL> data = List<WeightL>();

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future<dynamic> _onRefresh() {
    data.clear();
    return WeightL().listAll().then((value) {
      setState(() {
        this.data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ChartSeries<WeightL, DateTime>> chartData = data
        .map((e) => LineSeries<WeightL, DateTime>(
            dataSource: data,
            xValueMapper: (WeightL s, _) => DateTime.parse(s.createdDate),
            yValueMapper: (WeightL s, _) => s.weight,
            dataLabelSettings: DataLabelSettings(isVisible: true)))
        .toList();
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
          // Performs zooming on double tap
          enablePinching: true),
      primaryXAxis: CategoryAxis(),
      legend: Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: chartData,
    );
  }
}
