import 'package:flutter/material.dart';

class ScaffoldRoute extends StatefulWidget {
  Map<String, Widget> tabs;
  ScaffoldRoute(this.tabs, {Key key}) : super(key: key);
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute>
    with SingleTickerProviderStateMixin {
  TabController tabController; //需要定义一个Controller
  String titleName;

  @override
  void initState() {
    super.initState();
    titleName = widget.tabs.keys.first;
    // 创建Controller
    tabController = TabController(length: widget.tabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        titleName = widget.tabs.keys.toList()[tabController.index];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
        bottom: TabBar(
            controller: tabController,
            tabs: widget.tabs.keys.map((k) => Tab(text: k)).toList()),
      ),
      body: widget.tabs.values.toList()[tabController.index],
    );
  }
}
