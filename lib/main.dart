
import 'package:flutter/material.dart';
import 'package:scales/log.dart';
import 'package:scales/statistics.dart';
import 'package:scales/tabbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<String, Widget> map = {"记录": WeightLog(), "统计": Statistics()};
    return MaterialApp(
      title: 'Scales',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScaffoldRoute(map),
    );
  }
}
