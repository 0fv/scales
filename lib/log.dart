import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:scales/card/card.dart';
import 'package:scales/ocr.dart';

class WeightLog extends StatefulWidget {
  WeightLog({Key key}) : super(key: key);

  @override
  _WeightLogState createState() => _WeightLogState();
}

class _WeightLogState extends State<WeightLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[WeightCard(KG, DateTime.now(), 22.1, c)],
            ),
          ),
        ])),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.camera_enhance),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WeightOCR();
                }))));
  }
}
