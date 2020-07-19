import 'package:flutter/material.dart';

const String c = "读取";
const String h = "输入";
const String KG = "kg";

class WeightCard extends StatelessWidget {
  final DateTime dateTime;
  final double weight;
  final String source;
  final String uint;
  const WeightCard(this.uint, this.dateTime, this.weight, this.source,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateSlug =
        "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    return Container(
      child: ListTile(
        title: Text(weight.toString() + uint,
            style: TextStyle(color: Colors.red),
            textDirection: TextDirection.ltr),
        subtitle: Text("时间："+dateSlug),
        trailing: Text("来源：" + c,style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}
