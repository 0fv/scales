import 'package:flutter/material.dart';
import 'package:scales/card/card.dart';
import 'package:scales/model/weight_log.dart';
import 'package:scales/util/dateutil.dart';

class WeightLog extends StatefulWidget {
  WeightLog({Key key}) : super(key: key);

  @override
  _WeightLogState createState() => _WeightLogState();
}

class _WeightLogState extends State<WeightLog> {
  Future<List<WeightL>> wList;
  @override
  void initState() {
    super.initState();
    wList = WeightL().list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: wList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<WeightL> list = snapshot.data;
                if (list == null) {
                  return Container(
                    child: Center(
                      child: Text("无数据"),
                    ),
                  );
                } else {
                  return Container(
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 0.2, color: Colors.black26),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            var e = list[index];
                            return WeightCard(
                                e.id,
                                KG,
                                DateTime.parse(e.createdDate),
                                e.weight,
                                e.source,
                                key: Key("${e.id}"));
                          }));
                }
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Container();
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              bool flag = await WeightDiolog(context);
              if (flag != null && flag) {
                setState(() {
                  wList = WeightL().list();
                });
              }
            }
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return WeightOCR();
            // }))

            ));
  }
}

Future<bool> WeightDiolog(BuildContext context) {
  TextEditingController tec = new TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("新建"),
          content: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              width: 700,
              child: TextField(
                controller: tec,
                obscureText: false,
                keyboardType: TextInputType.number,
              )),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text("确定"),
              onPressed: () async {
                var w = double.parse(tec.text);
                await WeightL(
                        createdDate: DateUtil.formatDate(DateTime.now()),
                        weight: w)
                    .create();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
}
