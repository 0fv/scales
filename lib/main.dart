import 'package:flutter/material.dart';
import 'package:scales/log.dart';
import 'package:scales/model/model.dart';
import 'package:scales/statistics.dart';
import 'package:scales/tabbar.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<Database> db;
  @override
  Widget build(BuildContext context) {
    db = DBModel().initDB();
    Map<String, Widget> map = {"记录": WeightLog(), "统计": Statistics()};
    return MaterialApp(
      title: 'Scales',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: db,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ScaffoldRoute(map);
          } else if (snapshot.hasError) {
            return Container(child: Text(snapshot.error));
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
