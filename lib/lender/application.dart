import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';

class App2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: _buildShrineTheme(),
        home: FlutterEasyLoading(
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Application {
  String uid;
  String email;
  String name;
  double score;
  String puc;
  String la;
  String lt;
  String nca;
  String ca;
  String ta;
  String tl;
  String cl;
  String sc;
  String re;
  String net;
  String rev;
  String npbt;
  String npat;

  Application(
      {this.uid,
      this.email,
      this.name,
      this.score,
      this.puc,
      this.la,
      this.lt,
      this.nca,
      this.ca,
      this.ta,
      this.tl,
      this.cl,
      this.sc,
      this.re,
      this.net,
      this.rev,
      this.npbt,
      this.npat});
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  bool isLoading = false;

  List<Application> _applications = List<Application>();

  Future<void> updateStatus(int index, bool approval) async {
    var _app = _applications[index];
    databaseReference
        .child("applications/${_app.uid}")
        .update({"approval": approval});
  }

  Future<void> readData() async {
    var applications = List<Application>();
    setState(() {
      isLoading = true;
    });
    await databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value['applications'] != null) {
        // print(snapshot.value['applications']);
        snapshot.value['applications'].forEach((k, v) {
          if (v['approval'] == null) {
            // print(v['approval']);
            applications.add(Application(
              uid: k,
              email: v['email'],
              name: v['name'],
              score: v['credit score'],
              puc: v['Paid-up Capital'].toString(),
              la: v['Loan Amount'].toString(),
              lt: v['Loan Tenure'].toString(),
              nca: v['Non-Current Assets'].toString(),
              ca: v['Current Assets'].toString(),
              ta: v['Total Assets'].toString(),
              cl: v['Current Liabilities'].toString(),
              tl: v['Total Liabilities'].toString(),
              sc: v['Share Capital'].toString(),
              re: v['Retained Earnings'].toString(),
              net: v['Networth'].toString(),
              rev: v['Revenue'].toString(),
              npbt: v['Net Profit Before Tax'].toString(),
              npat: v['Net Profit After Tax'].toString(),
            ));
          }
        });
      }
    });

    setState(() {
      isLoading = false;
    });

    setState(() {
      _applications.addAll(applications);
    });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<dynamic> _refresh() {
    _applications = List();
    return readData();
  }

  Future<void> showMyDialog(BuildContext context, String displayText) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(displayText),
        );
      },
    );
  }

  Widget showConfirmDialog(BuildContext context, String label, int index) {
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
      content: Text("Are you sure you want to $label the application?"),
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
        if (label == 'accept') {
          updateStatus(index, true);
        } else if (label == 'reject') {
          updateStatus(index, false);
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (a, b, c) => App2(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      }
    });
    return null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Applications',
          ),
        ),
      ),
      body: RefreshIndicator(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: _applications.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(2),
                          itemCount: _applications.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () => showMyDialog(
                                    context,
                                    'Paid-up Capital: RM ${_applications[index].puc}\n' +
                                        'Loan Amount: RM ${_applications[index].la}\n' +
                                        'Loan Tenure: ${_applications[index].lt} months\n' +
                                        'Non-Current Assets: RM ${_applications[index].nca}\n' +
                                        'Current Assets: RM ${_applications[index].ca}\n' +
                                        'Total Assets: RM ${_applications[index].ta}\n' +
                                        'Current Liabilities: RM ${_applications[index].cl}\n' +
                                        'Total Liabilities: RM ${_applications[index].tl}\n' +
                                        'Share Capital: RM ${_applications[index].sc}\n' +
                                        'Retained Earnings: RM ${_applications[index].re}\n' +
                                        'Networth: RM ${_applications[index].net}\n' +
                                        'Revenue: RM ${_applications[index].rev}\n' +
                                        'Net Profit Before Tax: RM ${_applications[index].npbt}\n' +
                                        'Net Profit After Tax: RM ${_applications[index].npat}\n'),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading:
                                            Icon(Icons.verified_user_rounded),
                                        title: Text(
                                            '${_applications[index].name}'),
                                        subtitle: Text(
                                          '${_applications[index].email}',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'Credit Score: ${_applications[index].score}',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      ButtonBar(
                                        alignment: MainAxisAlignment.start,
                                        children: [
                                          FlatButton(
                                            onPressed: () {
                                              // Perform some action
                                              showConfirmDialog(
                                                  context, 'accept', index);
                                            },
                                            child: const Text('Accept'),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              // Perform some action
                                              showConfirmDialog(
                                                  context, 'reject', index);
                                            },
                                            child: const Text('Reject'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          })
                      : Center(
                          child: Text('No recent applications found'),
                        ),
                ),
          onRefresh: () => _refresh()),
    );
  }
}
