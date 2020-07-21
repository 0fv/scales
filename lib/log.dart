import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scales/card/card.dart';
import 'package:scales/model/weight_log.dart';
import 'package:scales/util/dateutil.dart';

class WeightLog extends StatefulWidget {
  WeightLog({Key key}) : super(key: key);

  @override
  _WeightLogState createState() => _WeightLogState();
}

class _WeightLogState extends State<WeightLog> {
  List<WeightL> data = List<WeightL>();
  ScrollController _scrollController;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  int page;
  int pageSize;
  var flag = true;

  @override
  void initState() {
    super.initState();
    page = 1;
    pageSize = 50;
    _scrollController = new ScrollController();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
    this._onRefresh();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onLoadmore();
      }
    });
  }

  Future<dynamic> _onRefresh() {
    data.clear();
    this.page = 1;
    return WeightL().list(limit: pageSize, page: page).then((value) {
      setState(() {
        this.data.addAll(value);
      });
    }).then((_) => {
          WeightL().count().then((value) {
            if (value < pageSize) {
              setState(() {
                flag = false;
              });
            }
          })
        });
  }

  Future<dynamic> _onLoadmore() {
    this.page++;
    return WeightL().list(limit: pageSize, page: page).then((data) {
      setState(() {
        if (data.length == 0) {
          flag = false;
        }
        this.data.addAll(data);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _loadMoreWidget() {
    return Visibility(
        visible: flag,
        child: Padding(
          padding: const EdgeInsets.all(15.0), // 外边距
          child: new Center(child: new CircularProgressIndicator()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Builder(builder: (context) {
            return Container(
                child: ListView.separated(
                    controller: _scrollController,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 0.2, color: Colors.black26),
                    itemCount: data.length+1,
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        return _loadMoreWidget();
                      }
                      var e = data[index];
                      return WeightCard(e.id, KG, DateTime.parse(e.createdDate),
                          e.weight, e.source,
                          key: Key("${e.id}"));
                    }));
          }),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              bool flag = await WeightDiolog(context);
              if (flag != null && flag) {
                _onRefresh();
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
