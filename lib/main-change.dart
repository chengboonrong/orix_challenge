import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/borrorwer/HomePage_B.dart';
import 'package:my_app/loginSignup.dart';

Future<bool> checkAuth() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool _result = prefs.getBool('auth');
  print('auth: $_result');
  print('googleSign: ${prefs.getBool('googleSign')}');
  return _result;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Widget _defaultHome = new LoginSignup();
  bool _check = false;
  checkAuth().then((result) => _check = result);
  if (_check) {
    _defaultHome = new Home();
  }

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new Home(),
      '/login': (BuildContext context) => new LoginSignup()
    },
  ));
}
