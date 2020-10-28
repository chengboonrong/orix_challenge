import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:countup/countup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/utils/authentication.dart' as GoogleSignIn;
import 'package:my_app/welcomePage.dart';

class App1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Number of registered users',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ShowNumbers()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ShowData()
          ],
        ),
      )),
    );
  }
}

class ShowNumbers extends StatefulWidget {
  ShowNumbers({Key key}) : super(key: key);

  @override
  _ShowNumbersState createState() => _ShowNumbersState();
}

class _ShowNumbersState extends State<ShowNumbers> {
  String uid;
  String email;
  String name;
  String imageUrl;
  bool checkGoogleSign = false;

  Future<void> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkGoogleSign = prefs.getBool('googleSign');
    var stringList = prefs.getStringList('uprofile') != null
        ? prefs.getStringList('uprofile')
        : prefs.getStringList('touchID_uprofile');

    setState(() {
      if (checkGoogleSign) {
        uid = stringList[0];
        name = stringList[1];
        email = stringList[2];
        imageUrl = stringList[3];
      } else {
        print(prefs.getStringList('uprofile'));
        uid = stringList[0];
        name = stringList[1];
        email = stringList[2];
      }
    });
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  List _users = List();

  Future readData() async {
    var users = List();

    await databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value['users'] != null) {
        snapshot.value['users'].forEach((k, v) => users.add(v));
      }
    });
    return users;
  }

  @override
  void initState() {
    super.initState();

    getUserProfile();
    // print('$checkGoogleSign, $name, $uid, $email');

    readData().then((value) {
      setState(() {
        _users.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Countup(
        textAlign: TextAlign.center,
        begin: 0,
        end: double.parse(_users.length.toString()),
        duration: Duration(seconds: 1),
        separator: ',',
        curve: Curves.fastLinearToSlowEaseIn,
        style: TextStyle(
          fontSize: 48,
        ),
      ),
      !checkGoogleSign
          ? GestureDetector(
              child: Hero(
                tag: 'photo',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 18, left: 33, right: 33),
                        color: Colors.lightBlueAccent,
                        child: Text(
                          '${name.toString().toUpperCase().substring(0, 1)}',
                          style: TextStyle(color: Colors.white, fontSize: 50),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return Scaffold(
                            body: Container(
                              // The blue background emphasizes that it's a new route.
                              // color: Colors.lightBlueAccent,
                              padding: const EdgeInsets.only(
                                  top: 250, left: 16, right: 16),
                              child: Column(children: <Widget>[
                                Hero(
                                  tag: 'photo',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 18,
                                            bottom: 18,
                                            left: 33,
                                            right: 33),
                                        color: Colors.lightBlueAccent,
                                        child: Text(
                                          '${name.toString().toUpperCase().substring(0, 1)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 50),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '$name\n',
                                          style: TextStyle(fontSize: 30)),
                                      TextSpan(
                                        text: 'UID: $uid\n',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: 'Email: $email\n',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {
                                    GoogleSignIn.signOutGoogle();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WelcomePage()),
                                    );
                                  },
                                  color: Colors.redAccent,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.exit_to_app,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text('Log out of Google',
                                            style:
                                                TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          );
                        }));
                      }),
                ),
              ),
            )
          : GestureDetector(
              child: PhotoHero(
                  photo: '$imageUrl',
                  // width: 300.0,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return Scaffold(
                        body: Container(
                          // The blue background emphasizes that it's a new route.
                          // color: Colors.lightBlueAccent,
                          padding: const EdgeInsets.only(
                              top: 250, left: 16, right: 16),
                          child: Column(children: <Widget>[
                            PhotoHero(
                              photo: '$imageUrl',
                              width: 100.0,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '',
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$name\n',
                                      style: TextStyle(fontSize: 30)),
                                  TextSpan(
                                    text: 'UID: $uid\n',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: 'Email: $email\n',
                                    style: TextStyle(
                                        color: Colors.blueGrey, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                GoogleSignIn.signOutGoogle();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomePage()),
                                );
                              },
                              color: Colors.redAccent,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.exit_to_app,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Log out of Google',
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }));
                  }),
            ),
      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '$email',
          style: DefaultTextStyle.of(context).style,
        ),
      ),
    ]));
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class ShowData extends StatefulWidget {
  ShowData({Key key}) : super(key: key);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List<int> numberList = [0, 0, 0];
  List<String> stringList = ['Application', 'Accept', 'Reject'];

  Future<void> getApplicationData() async {
    var _applicationCount = 0;
    var accepts = List();
    var rejects = List();
    await databaseReference
        .child("applications")
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        _applicationCount = snapshot.value.length;
        // print(snapshot.value);
        snapshot.value.forEach((k, v) {
          if (v['Approval'] != null) {
            v['Approval'] ? accepts.add(k) : rejects.add(k);
          }
        });
      }
    });

    // print('$_applicationCount, $rejectCount, $acceptCount');

    setState(() {
      numberList[0] = (_applicationCount);
      numberList[1] = (accepts.length);
      numberList[2] = (rejects.length);
    });
  }

  @override
  void initState() {
    super.initState();

    getApplicationData();
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 180, // card height
      child: PageView.builder(
          itemCount: 3,
          controller: PageController(viewportFraction: 0.7),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(children: [
                    Text(
                      "${stringList[_index]}",
                      style: TextStyle(fontSize: 26),
                    ),
                    Text(
                      "${numberList[_index]}",
                      style: TextStyle(fontSize: 36),
                    ),
                  ]),
                ),
              ),
            );
          }),
    )
        // Column(
        //   children: <Widget>[
        //     Card(
        //       child: Padding(
        //         padding: EdgeInsets.all(16.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Text(
        //               'Applications',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(fontSize: 20),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text(
        //               '$applicationCount',
        //               textAlign: TextAlign.center,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Card(
        //       child: Padding(
        //         padding: EdgeInsets.all(16.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Text(
        //               'Applications',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(fontSize: 20),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text(
        //               '$applicationCount',
        //               textAlign: TextAlign.center,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Card(
        //       child: Padding(
        //         padding: EdgeInsets.all(16.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.stretch,
        //           children: [
        //             Text(
        //               'Applications',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(fontSize: 20),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text(
        //               '$applicationCount',
        //               textAlign: TextAlign.center,
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // ),

        );
  }
}
