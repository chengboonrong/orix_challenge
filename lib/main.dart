import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:my_app/lender/HomePage_L.dart';
import 'package:my_app/borrower/HomePage_B.dart';
import 'package:my_app/loginSignup.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

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
    home: AnimatedSplashScreen(
      splash: 'lib/assets/flutter.png',
      nextScreen: _defaultHome,
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.scale,
    ),
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new Home(),
      '/login': (BuildContext context) => new LoginSignup()
    },
  ));

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false;
}
