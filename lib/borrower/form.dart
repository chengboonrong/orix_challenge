import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/authentication.dart' as Auth;
// import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  final nca_cyController = TextEditingController();
  final ca_cyController = TextEditingController();
  final ta_cyController = TextEditingController();
  final cl_cyController = TextEditingController();
  final tl_cyController = TextEditingController();
  final sc_cyController = TextEditingController();
  final re_cyController = TextEditingController();
  final net_cyController = TextEditingController();
  final rev_cyController = TextEditingController();
  final npbt_cyController = TextEditingController();
  final npat_cyController = TextEditingController();
  final nca_lyController = TextEditingController();
  final ca_lyController = TextEditingController();
  final ta_lyController = TextEditingController();
  final cl_lyController = TextEditingController();
  final tl_lyController = TextEditingController();
  final sc_lyController = TextEditingController();
  final re_lyController = TextEditingController();
  final net_lyController = TextEditingController();
  final rev_lyController = TextEditingController();
  final npbt_lyController = TextEditingController();
  final npat_lyController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    pucController.dispose();
    laController.dispose();
    ltController.dispose();
    nca_cyController.dispose();
    ca_cyController.dispose();
    ta_cyController.dispose();
    cl_cyController.dispose();
    tl_cyController.dispose();
    sc_cyController.dispose();
    re_cyController.dispose();
    net_cyController.dispose();
    rev_cyController.dispose();
    npbt_cyController.dispose();
    npat_cyController.dispose();
    nca_lyController.dispose();
    ca_lyController.dispose();
    ta_lyController.dispose();
    cl_lyController.dispose();
    tl_lyController.dispose();
    sc_lyController.dispose();
    re_lyController.dispose();
    net_lyController.dispose();
    rev_lyController.dispose();
    npbt_lyController.dispose();
    npat_lyController.dispose();
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
                      _customTextField(nca_cyController,
                          'Non-Current Assets (Current year)', true),
                      _customTextField(ca_cyController,
                          'Current Assets (Current year)', true),
                      _customTextField(
                          ta_cyController, 'Total Assets (Current year)', true),
                      _customTextField(cl_cyController,
                          'Current Liabilities (Current year)', true),
                      _customTextField(tl_cyController,
                          'Total Liabilities (Current year)', true),
                      _customTextField(sc_cyController,
                          'Share Capital (Current year)', true),
                      _customTextField(re_cyController,
                          'Retained Earnings (Current year)', true),
                      _customTextField(
                          net_cyController, 'Networth (Current year)', true),
                      _customTextField(
                          rev_cyController, 'Revenue (Current year)', true),
                      _customTextField(npbt_cyController,
                          'Net Profit Before Tax (Current year)', true),
                      _customTextField(npat_cyController,
                          'Net Profit After Tax (Current year)', true),
                      _customTextField(nca_lyController,
                          'Non-Current Assets (Last year)', true),
                      _customTextField(
                          ca_lyController, 'Current Assets (Last year)', true),
                      _customTextField(
                          ta_lyController, 'Total Assets (Last year)', true),
                      _customTextField(cl_lyController,
                          'Current Liabilities (Last year)', true),
                      _customTextField(tl_lyController,
                          'Total Liabilities (Last year)', true),
                      _customTextField(
                          sc_lyController, 'Share Capital (Last year)', true),
                      _customTextField(re_lyController,
                          'Retained Earnings (Last year)', true),
                      _customTextField(
                          net_lyController, 'Networth (Last year)', true),
                      _customTextField(
                          rev_lyController, 'Revenue (Last year)', true),
                      _customTextField(npbt_lyController,
                          'Net Profit Before Tax (Last year)', true),
                      _customTextField(npat_lyController,
                          'Net Profit After Tax (Last year)', true),
                      RaisedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            print('all blanks are filled');
                            createCustomer(
                              pucController.text,
                              laController.text,
                              ltController.text,
                              (double.parse(nca_cyController.text) -
                                          double.parse(nca_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(ca_cyController.text) -
                                          double.parse(ca_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(ta_cyController.text) -
                                          double.parse(ta_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(cl_cyController.text) -
                                          double.parse(cl_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(tl_cyController.text) -
                                          double.parse(tl_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(sc_cyController.text) -
                                          double.parse(sc_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(re_cyController.text) -
                                          double.parse(re_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(net_cyController.text) -
                                          double.parse(net_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(rev_cyController.text) -
                                          double.parse(rev_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(npbt_cyController.text) -
                                          double.parse(
                                              npbt_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                              (double.parse(npat_cyController.text) -
                                          double.parse(
                                              npat_lyController.text)) >
                                      0
                                  ? '1'
                                  : '-1',
                            );

                            //
                            double _progress = 0;
                            Timer _timer;
                            _timer?.cancel();
                            _timer = Timer.periodic(
                                const Duration(milliseconds: 100),
                                (Timer timer) {
                              EasyLoading.showProgress(_progress,
                                  status:
                                      '${(_progress * 100).toStringAsFixed(0)}%');
                              _progress += 0.03;

                              if (_progress >= 1) {
                                _timer?.cancel();
                                EasyLoading.dismiss();
                                EasyLoading.showSuccess(
                                    'You have successfully sent the application. Please head to "View Status" to see your application progress');
                              }
                            });
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
