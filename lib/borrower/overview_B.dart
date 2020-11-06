import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/utils/authentication.dart' as GoogleSignIn;
import 'package:my_app/welcomePage.dart';
import 'package:carousel_pro/carousel_pro.dart';

class App1 extends StatefulWidget {
  App1({Key key}) : super(key: key);

  @override
  _App1State createState() => _App1State();
}

class _App1State extends State<App1> {
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
        // print(prefs.getStringList('uprofile'));
        uid = stringList[0];
        name = stringList[1];
        email = stringList[2];
      }
    });
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  // List _users = List();
  List _applications = List();
  bool _gtData = false;
  bool isLoading = true;
  List<Color> colors = [Colors.amber, Colors.green, Colors.red];
  List<String> status = ["Processing", "Accepted", "Rejected"];

  Future readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var applications = List();
    var gtData = true;

    await databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value['users'] != null) {
        var currentUser = prefs.getStringList('uprofile') != null
            ? prefs.getStringList('uprofile')
            : prefs.getStringList('touchID_uprofile');

        int len = currentUser[2].length;
        String dbID = currentUser[2].substring(0, len - 4);
        // print(snapshot.value['users'][dbID]['applications']);

        snapshot.value['users'][dbID]['applications'] != null
            ? snapshot.value['users'][dbID]['applications']
                .forEach((k, v) => applications.add(v))
            : gtData = false;
      }

      setState(() {
        _gtData = gtData;
        _applications.addAll(applications);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getUserProfile();

    readData().then((value) {
      setState(() {
        print(_applications);
      });
    });
  }

  Future<dynamic> _refresh() {
    _applications = List();
    return readData();
  }

  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Builder(
                builder: (context) => IconButton(
                      icon: Icon(Icons.account_circle),
                      iconSize: 40,
                      color: Colors.black,
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    )),
          ),
        ),
        backgroundColor: Colors.white24,
        elevation: 0,
      ),
      body: Column(children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 4.0),
            child: Text(
              'Hello ${name.toString().toUpperCase()},',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Raleway'),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
            child: Text(
              'What do you want to do today?',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16, color: Colors.grey, fontFamily: 'Raleway'),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            child: Text(
              'User Manual',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono'),
            ),
          ),
        ),
        SizedBox(
            height: 200.0,
            width: 350.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      offset: Offset(0,3)//bottom right 
                      )
                    ]),
                  child: Carousel(
                    images: [
                      ExactAssetImage("lib/assets/1.png"),
                      ExactAssetImage("lib/assets/2.png"),
                      ExactAssetImage("lib/assets/3.png"),
                      ExactAssetImage("lib/assets/4.png"),
                      ExactAssetImage("lib/assets/5.png"),
                      ExactAssetImage("lib/assets/6.png"),
                    ],
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.black,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.purple.withOpacity(0),
                    borderRadius: true,
                  ),
                ),
              ),
            )),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
            child: Text(
              'Status Overview',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: RefreshIndicator(
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          child: !_gtData
                              ? Text('No application submitted')
                              : ListView.builder(
                                  itemCount: _applications.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 20),
                                                child: Text(
                                                  index.toString(),
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              ),
                                              Container(
                                                height: 40.0,
                                                width: 1.0,
                                                color: Colors.black38,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Application ID: ${_applications[index]['appID'].toString()}'),
                                                  Text(
                                                      'Time created: ${_applications[index]['time'].toString()}')
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: colors[
                                                        _applications[index]
                                                            ['status']],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60)),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Text(
                                                  '${status[_applications[index]['status']]}',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                ),
                onRefresh: () => _refresh(),
              ),
            ),
          ),
        ),
      ]),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.blueAccent,
                Colors.lightBlueAccent
              ])),
              child: Center(
                child: Column(
                  children: <Widget>[
                    !checkGoogleSign
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      // color: Colors.transparent,
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius:
                                              BorderRadius.circular(60)),
                                      padding: const EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 20,
                                          right: 20),
                                      // color: Colors.lightBlueAccent,
                                      child: Text(
                                        '${name.toString().toUpperCase().substring(0, 1)}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Column(
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: '$name\n',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'UID: $uid\n',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                            ),
                                            TextSpan(
                                              text: 'Email: $email\n',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl),
                                      radius: 30,
                                    )
                                    // Image.network(imageUrl),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Column(
                                    children: <Widget>[
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          text: '$name\n',
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 20),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'UID: $uid\n',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 12),
                                            ),
                                            TextSpan(
                                              text: 'Email: $email\n',
                                              style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text("About us"),
              onTap: () {},
            ),
            Padding(
                padding: const EdgeInsets.only(top: 0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () {
                        GoogleSignIn.signOutGoogle();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()),
                        );
                      },
                      color: Colors.redAccent,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.exit_to_app, color: Colors.white),
                          Text('Log out', style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
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
