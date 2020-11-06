import 'package:flutter/material.dart';
import 'package:my_app/borrower/HomePage_B.dart';
// import 'package:my_app/lender/HomePage_L.dart';
import 'package:my_app/forgotPassword.dart';
import 'package:my_app/registerPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/welcomePage.dart';
import 'package:my_app/widgets/bezierContainer.dart';
import 'package:my_app/utils/authentication.dart' as GoogleSignIn;
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:my_app/utils/biometric.dart' as Bio;

import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //biometric variable
  bool _firstTime = false;
  bool hasBio = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    GoogleSignIn.isFirstTime().then((value) {
      print('first time: $value');
      setState(() {
        _firstTime = value; // if first time then show Tutorial Dialog
      });
    });

    if (Bio.checkBiometrics() != null) {
      Bio.getAvailableBiometrics().then((value) => print(value));
      setState(() {
        hasBio = true;
      });
    }
  }

  // Widget _backButton() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => WelcomePage()));
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10),
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
  //             child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
  //           ),
  //           Text('Back',
  //               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _entryField(String title, {bool isPassword = false}) {
    var _controller;
    if (title == "Email") {
      _controller = _emailController;
    } else if (title == "Password") {
      _controller = _passwordController;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: _controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
        onTap: () async {
          // print('Submitted !');
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          await GoogleSignIn.signInWithEmailPassword(
                  _emailController.text.trim(), _passwordController.text.trim())
              .then((result) {
            if (result == 'success') {
              Fluttertoast.showToast(
                  msg: _firstTime ? 'Welcome to the app!' : 'Welcome Back!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black87,
                  fontSize: 16.0);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => Home(),
                ),
              );
            } else {
              // print(result);
              Fluttertoast.showToast(
                  msg: '$result',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return SignInButton(Buttons.Google,
        // mini: true,
        text: "Sign In with Google", onPressed: () async {
      setState(() {});
      await GoogleSignIn.signInWithGoogle().then((result) {
        if (result != null) {
          Fluttertoast.showToast(
              msg: "Welcome Back !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black87,
              fontSize: 16.0);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => Home(),
            ),
          );
        }
      }).catchError((error) {
        print('$error');
      });
      setState(() {});
    });
  }

  // Widget _facebookButton() {
  //   return SignInButton(Buttons.Facebook,
  //       // mini: true,
  //       text: "Sign In with Facebook", onPressed: () async {
  //     setState(() {});
  //     await GoogleSignIn.signInWithGoogle().then((result) {
  //       if (result != null) {
  //         // Navigator.of(context).pop();
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(
  //             fullscreenDialog: true,
  //             builder: (context) => Home(),
  //           ),
  //         );
  //       }
  //     }).catchError((error) {
  //       print('Registration Error: $error');
  //     });
  //     setState(() {});
  //   });
  // }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpPage()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'The',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: '97',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ers',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  Widget _forgotButton() {
    return FlatButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.centerRight,
          child: Text('Forgot Password ?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ));
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 0, bottom: 0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () async {
                  await Bio.authenticate().then((value) {
                    if (value) {
                      print(value);
                      Future.delayed(Duration(seconds: 1)).then((value) {
                        Fluttertoast.showToast(
                            msg: "Welcome Back !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black87,
                            fontSize: 12.0);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      });
                    } else {
                      Future.delayed(Duration(seconds: 1)).then((value) {
                        Fluttertoast.showToast(
                            msg: "Canceled",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black87,
                            fontSize: 16.0);
                      });
                    }
                  });
                },
                child: Icon(Icons.fingerprint, size: 25, color: Colors.grey)),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container(
      height: height,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .17),
                  _title(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  if (_firstTime == false) _label(),
                  _forgotButton(),
                  _divider(),
                  _googleButton(),
                  _createAccountLabel(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
