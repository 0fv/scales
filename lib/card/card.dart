import 'package:flutter/material.dart';
import 'package:scales/model/weight_log.dart';

const String c = "读取";
const String h = "输入";
const String KG = "kg";

class WeightCard extends StatelessWidget {
  final DateTime dateTime;
  final double weight;
  final String source;
  final String uint;
  final int id;
  const WeightCard(this.id, this.uint, this.dateTime, this.weight, this.source,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateSlug =
        "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    return Dismissible(
        key: key,
        child: Container(
          margin: EdgeInsets.all(7),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(weight.toString() + " " + uint,
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                    textDirection: TextDirection.ltr),
                subtitle: Text("时间：" + dateSlug),
                trailing: Text(
                  "来源：" + (source == null ? h : source),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        background: Container(
          color: Colors.white10,
        ),
        secondaryBackground: Container(
          padding: EdgeInsets.fromLTRB(7, 15, 7, 7),
          color: Colors.red,
          child: ListTile(
            trailing: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        confirmDismiss: (direction) async {
          var _confirmContent;

          var _alertDialog;
          if (direction == DismissDirection.endToStart) {
            _confirmContent = '确认删除？';
            _alertDialog = _createDialog(
              _confirmContent,
              () {
                // 展示 SnackBar
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('已删除'),
                  duration: Duration(milliseconds: 1000),
                ));
                WeightL().delete(id);
                Navigator.of(context).pop(true);
              },
              context,
            );
            var isDismiss = await showDialog(
                context: context,
                builder: (context) {
                  return _alertDialog;
                });
            return isDismiss;
          } else {
            return Future<bool>.value(false);
          }
        });
  }

  Widget _createDialog(
      String content, Function() confirm, BuildContext context) {
    return AlertDialog(
      content: Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          width: 700,
          child: Text(content)),
      actions: <Widget>[
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(child: Text("确定"), onPressed: confirm),
      ],
    );
  }
}
