import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final myNumsController = TextEditingController();
  final myNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myNumsController.dispose();
    myNameController.dispose();
    super.dispose();
  }

  void createData() {
    databaseReference
        .child("users/0")
        .set({'name': 'Deepak Nishad', 'description': 'Team Lead'});
  }

  Future createCustomer(
      String name, String num1, String num2, String num3) async {
    List<double> doubleList = [
      double.parse(num1),
      double.parse(num2),
      double.parse(num3)
    ];
    // print(num1);

    final http.Response response = await http.post(
      // 'https://orixc-f5a94.firebaseio.com/users.json',
      'https://flask-fire-v10-23jjq2lt2q-de.a.run.app/api/sample',
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
      databaseReference.child("applications/${Uuid().v4()}").set({
        'name': name,
        'num1': num1,
        'num2': num2,
        'num3': num3,
        'score': json.decode(response.body)['score'],
      });
      EasyLoading.showSuccess('Sent successfully!');
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to send request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 43),
            child: GestureDetector(
                child: Form(
                    key: _formKey,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: myNameController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                              TextFormField(
                                controller: myNumsController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your numbers';
                                  }
                                  return null;
                                },
                                decoration:
                                    InputDecoration(labelText: 'Numbers'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    createCustomer(
                                        myNameController.text,
                                        myNumsController.text,
                                        myNumsController.text,
                                        myNumsController.text);
                                  }
                                },
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ))))));
  }
}
