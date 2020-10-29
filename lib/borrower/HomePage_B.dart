import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/borrower/form.dart';
import 'package:my_app/borrower/overview_B.dart';
import 'dart:io';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isIn = prefs.getBool('auth');
    if (isIn) {
      print('Signed in');
    }
  }

  @override
  void initState() {
    super.initState();
    // checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap: () => exit(0),
              child: Text("YES"),
            ),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Stack(children: <Widget>[
          DefaultTabController(
            length: 2,
            child: Scaffold(
              // appBar: AppBar(
              // title: Center(child: Text('Borrower View')),
              // ),
              body: TabBarView(
                children: [
                  App1(),
                  App3(),
                ],
              ),
              bottomNavigationBar: Container(
                color: Colors.blueAccent,
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white30,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(5.0),
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.assessment),
                      text: 'Status',
                    ),
                    Tab(
                      icon: Icon(Icons.drafts),
                      text: 'Apply',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
