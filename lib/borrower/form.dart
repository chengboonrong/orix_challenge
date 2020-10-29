import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class App3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FlutterEasyLoading(
          child: new MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  final valueList = ["-1", "0", "1"];

  List<String> userProfile = List<String>();

  bool checkGoogleSign = false;

  Future<void> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkGoogleSign = prefs.getBool('googleSign');
    var stringList = prefs.getStringList('uprofile') != null
        ? prefs.getStringList('uprofile')
        : prefs.getStringList('touchID_uprofile');

    setState(() {
      userProfile = stringList;
    });
  }

  void createCustomer(
      String puc,
      String la,
      String lt,
      String nca,
      String ca,
      String ta,
      String cl,
      String tl,
      String sc,
      String re,
      String net,
      String rev,
      String npbt,
      String npat) async {
    List<double> doubleList = [
      double.parse(puc),
      double.parse(la),
      double.parse(lt),
      double.parse(nca),
      double.parse(ca),
      double.parse(ta),
      double.parse(cl),
      double.parse(tl),
      double.parse(sc),
      double.parse(re),
      double.parse(net),
      double.parse(rev),
      double.parse(npbt),
      double.parse(npat),
    ];
    // print(num1);

    final http.Response response = await http.post(
      'https://flask-fire-v10-23jjq2lt2q-de.a.run.app/api/v1',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'data': doubleList,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print('Sent!');
      print(response.body);

      var _uuid = Uuid().v4();

      // save to applications ref
      databaseReference.child("applications/$_uuid").set({
        'name': userProfile[1],
        'email': userProfile[2],
        'Paid-up Capital': puc,
        'Loan Amount': la,
        'Loan Tenure': lt,
        'Non-Current Assets': nca,
        'Current Assets': ca,
        'Total Assets': ta,
        'Current Liabilities': cl,
        'Total Liabilities': tl,
        'Share Capital': sc,
        'Retained Earnings': re,
        'Networth': net,
        'Revenue': rev,
        'Net Profit Before Tax': npbt,
        'Net Profit After Tax': npat,
        'credit score': json.decode(response.body)['score'],
      });

      var _email = userProfile[2];
      _email = _email.substring(0, _email.length - 4);

      // save to $user applications ref
      databaseReference.child("users/$_email/applications/$_uuid").set({
        "appID": Uuid().v4().substring(0, 6),
        "time": new DateFormat.yMMMd().format(new DateTime.now()).toString(),
        "status": 0,
      });

      print('Sent successfully!');
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send request');
    }
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final pucController = TextEditingController();
  final laController = TextEditingController();
  final ltController = TextEditingController();
  final ncaCYController = TextEditingController();
  final caCYController = TextEditingController();
  final taCYController = TextEditingController();
  final clCYController = TextEditingController();
  final tlCYController = TextEditingController();
  final scCYController = TextEditingController();
  final reCYController = TextEditingController();
  final netCYController = TextEditingController();
  final revCYController = TextEditingController();
  final npbtCYController = TextEditingController();
  final npatCYController = TextEditingController();
  final ncaLYController = TextEditingController();
  final caLYController = TextEditingController();
  final taLYController = TextEditingController();
  final clLYController = TextEditingController();
  final tlLYController = TextEditingController();
  final scLYController = TextEditingController();
  final reLYController = TextEditingController();
  final netLYController = TextEditingController();
  final revLYController = TextEditingController();
  final npbtLYController = TextEditingController();
  final npatLYController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    pucController.dispose();
    laController.dispose();
    ltController.dispose();
    ncaCYController.dispose();
    caCYController.dispose();
    taCYController.dispose();
    clCYController.dispose();
    tlCYController.dispose();
    scCYController.dispose();
    reCYController.dispose();
    netCYController.dispose();
    revCYController.dispose();
    npbtCYController.dispose();
    npatCYController.dispose();
    ncaLYController.dispose();
    caLYController.dispose();
    taLYController.dispose();
    clLYController.dispose();
    tlLYController.dispose();
    scLYController.dispose();
    reLYController.dispose();
    netLYController.dispose();
    revLYController.dispose();
    npbtLYController.dispose();
    npatLYController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getUserProfile();
  }

  Widget _customTextField(
      TextEditingController myController, String label, bool specialCase) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: TextFormField(
        controller: myController,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: label),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please fill in the blank. Type "0" if it is empty.';
          } else if (int.tryParse(value) == null) {
            return 'Only integers are allowed';
          } else if (myController == ltController && int.parse(value) > 60) {
            return 'Should not be more than 60 months';
          } else if (myController == ltController && int.parse(value) <= 0) {
            return 'Should not be less than 1 month';
          }
          return null;
        },
      ),
    );
  }

  Widget showConfirmDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to submit the application?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((result) {
      if (result) {
        print('Yes to submit');
        print('All blanks are filled');
        createCustomer(
          pucController.text,
          laController.text,
          ltController.text,
          (double.parse(ncaCYController.text) -
                      double.parse(ncaLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(caCYController.text) -
                      double.parse(caLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(taCYController.text) -
                      double.parse(taLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(clCYController.text) -
                      double.parse(clLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(tlCYController.text) -
                      double.parse(tlLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(scCYController.text) -
                      double.parse(scLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(reCYController.text) -
                      double.parse(reLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(netCYController.text) -
                      double.parse(netLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(revCYController.text) -
                      double.parse(revLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(npbtCYController.text) -
                      double.parse(npbtLYController.text)) >
                  0
              ? '1'
              : '-1',
          (double.parse(npatCYController.text) -
                      double.parse(npatLYController.text)) >
                  0
              ? '1'
              : '-1',
        );

        //
        double _progress = 0;
        Timer _timer;
        _timer?.cancel();
        _timer =
            Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
          EasyLoading.showProgress(_progress,
              status: '${(_progress * 100).toStringAsFixed(0)}%');
          _progress += 0.03;

          if (_progress >= 1) {
            _timer?.cancel();
            EasyLoading.dismiss();
            EasyLoading.showSuccess(
                'You have successfully sent the application. Please head to "View Status" to see your application progress');
          }
        });
      }
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new FlutterEasyLoading(
      child: Scaffold(
        appBar: AppBar(title: Text('Request Application')),
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          'All the information will not be shared to others',
                          style:
                              TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _customTextField(pucController, 'Paid-up Capital', false),
                      _customTextField(laController, 'Loan Amount', false),
                      _customTextField(ltController, 'Loan Tenure', false),
                      _customTextField(ncaCYController,
                          'Non-Current Assets (Current year)', true),
                      _customTextField(caCYController,
                          'Current Assets (Current year)', true),
                      _customTextField(
                          taCYController, 'Total Assets (Current year)', true),
                      _customTextField(clCYController,
                          'Current Liabilities (Current year)', true),
                      _customTextField(tlCYController,
                          'Total Liabilities (Current year)', true),
                      _customTextField(
                          scCYController, 'Share Capital (Current year)', true),
                      _customTextField(reCYController,
                          'Retained Earnings (Current year)', true),
                      _customTextField(
                          netCYController, 'Networth (Current year)', true),
                      _customTextField(
                          revCYController, 'Revenue (Current year)', true),
                      _customTextField(npbtCYController,
                          'Net Profit Before Tax (Current year)', true),
                      _customTextField(npatCYController,
                          'Net Profit After Tax (Current year)', true),
                      _customTextField(ncaLYController,
                          'Non-Current Assets (Last year)', true),
                      _customTextField(
                          caLYController, 'Current Assets (Last year)', true),
                      _customTextField(
                          taLYController, 'Total Assets (Last year)', true),
                      _customTextField(clLYController,
                          'Current Liabilities (Last year)', true),
                      _customTextField(tlLYController,
                          'Total Liabilities (Last year)', true),
                      _customTextField(
                          scLYController, 'Share Capital (Last year)', true),
                      _customTextField(reLYController,
                          'Retained Earnings (Last year)', true),
                      _customTextField(
                          netLYController, 'Networth (Last year)', true),
                      _customTextField(
                          revLYController, 'Revenue (Last year)', true),
                      _customTextField(npbtLYController,
                          'Net Profit Before Tax (Last year)', true),
                      _customTextField(npatLYController,
                          'Net Profit After Tax (Last year)', true),
                      RaisedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          print('Sending ...');
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                            showConfirmDialog(context);
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
