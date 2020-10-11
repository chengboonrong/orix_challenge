import 'package:flutter/material.dart';
import 'package:test_app/app.dart';
import 'package:test_app/form.dart';
import 'package:test_app/overview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(TabBarDemo());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..userInteractions = true;
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(children: <Widget>[
          DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.assessment),
                      text: 'Overview',
                    ),
                    Tab(
                      icon: Icon(Icons.history),
                      text: 'Applications',
                    ),
                    Tab(
                      icon: Icon(Icons.folder),
                      text: 'Form',
                    ),
                  ],
                ),
                title: Text('Lenders View'),
              ),
              body: TabBarView(
                children: [
                  App1(),
                  App2(),
                  App3(),
                ],
              ),
            ),
          ),
        ]));
  }
}
