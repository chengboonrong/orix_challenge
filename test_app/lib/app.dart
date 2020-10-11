import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/entities/customer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';

class App2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: _buildShrineTheme(),
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

class User {
  String name;
  String description;

  User({this.name, this.description});
}

class _MyHomePageState extends State<MyHomePage> {
  List<Customer> _customers = List<Customer>();

  final databaseReference = FirebaseDatabase.instance.reference();

  List<User> _users = List<User>();

  Future<List<User>> readData() async {
    var users = List<User>();

    await databaseReference.once().then((DataSnapshot snapshot) {
      snapshot.value['users'].forEach((k) {
        _users.add(User(
          name: k['name'],
          description: k['description'],
        ));
        print(k);
      });
    });
    return users;
  }

  // Future<List<Customer>> fetchCustomers() async {
  //   var url =
  //       // 'https://raw.githubusercontent.com/chengboonrong/orix_challenge/main/dataset_all.json';
  //       'https://a205-282002.firebaseio.com/.json';
  //   var response = await http.get(url);

  //   var customers = List<Customer>();

  //   if (response.statusCode == 200) {
  //     var customersJson = json.decode(response.body);
  //     // print(customersJson[0]);
  //     customersJson.forEach((k) => customers.add(Customer(
  //         index: k,
  //         year: k['Year of Incorporated'].toString(),
  //         industry: k['Industry'],
  //         loanStatus: k['Loan Status'],
  //         loanAmount: k['Loan Amount'].toString(),
  //         loanTenure: k['Loan Tenure'].toString(),
  //         paidUpCapital: k['Paid-up Capital'].toString())));
  //   }

  //   return customers;
  // }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      // fetchCustomers().then((value) {
      //   setState(() {
      //     _customers.addAll(value);
      //   });
      // });

      readData().then((value) {
        setState(() {
          _users.addAll(value);
        });
      });
    });
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

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            // itemCount: _customers.length,
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => showMyDialog(
                      context,
                      // 'Loan Amount: RM ${_customers[index].loanAmount}\nLoan Tenure: ${_customers[index].loanTenure} months'),
                      ''),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.verified_user_rounded),
                          title:
                              // Text('Company ${_customers[index].index}'),
                              Text('${_users[index].name}'),
                          subtitle: Text(
                            '${_users[index].description}',
                            // '',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            // 'Loan Status: ${_customers[index].loanStatus}',
                            'Description: blah blah blah',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: [
                            FlatButton(
                              onPressed: () {
                                // Perform some action
                              },
                              child: const Text('Accept'),
                            ),
                            FlatButton(
                              onPressed: () {
                                // Perform some action
                              },
                              child: const Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            }));
  }
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    accentColor: shrineBrown900,
    primaryColor: shrinePink100,
    buttonColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    textSelectionColor: shrinePink100,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headline5: base.headline5.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: defaultLetterSpacing,
        ),
        headline6: base.headline6.copyWith(
          fontSize: 18,
          letterSpacing: defaultLetterSpacing,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        bodyText2: base.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: defaultLetterSpacing,
        ),
        bodyText1: base.bodyText1.copyWith(
          letterSpacing: defaultLetterSpacing,
        ),
        subtitle1: base.subtitle1.copyWith(
          letterSpacing: defaultLetterSpacing,
        ),
        headline4: base.headline4.copyWith(
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;
