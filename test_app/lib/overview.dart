import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class App1 extends StatelessWidget {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Realtime Database Demo'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: Text('Create Data'),
              color: Colors.redAccent,
              onPressed: () {
                createData();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              child: Text('Read/View Data'),
              color: Colors.redAccent,
              onPressed: () {
                readData();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              child: Text('Update Data'),
              color: Colors.redAccent,
              onPressed: () {
                updateData();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              child: Text('Delete Data'),
              color: Colors.redAccent,
              onPressed: () {
                deleteData();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ],
        ),
      )), //center
    );
  }

  void createData() {
    databaseReference
        .child("users/0")
        .set({'name': 'Deepak Nishad', 'description': 'Team Lead'});
    databaseReference.child("users/1").set(
        {'name': 'Yashwant Kumar', 'description': 'Senior Software Engineer'});
    databaseReference
        .child("users/2")
        .set({'name': 'Akshay', 'description': 'Software Engineer'});
    databaseReference
        .child("users/3")
        .set({'name': 'Aditya', 'description': 'Software Engineer'});
    databaseReference
        .child("users/4")
        .set({'name': 'Shaiq', 'description': 'Associate Software Engineer'});
    databaseReference
        .child("users/5")
        .set({'name': 'Mohit', 'description': 'Associate Software Engineer'});
    databaseReference
        .child("users/6")
        .set({'name': 'Naveen', 'description': 'Associate Software Engineer'});
  }

  void readData() {
    databaseReference.once().then((DataSnapshot snapshot) {
      snapshot.value['users'].forEach((k) {
        print(k);
      });
    });
  }

  void updateData() {
    databaseReference.child('flutterDevsTeam1').update({'description': 'CEO'});
    databaseReference
        .child('flutterDevsTeam2')
        .update({'description': 'Team Lead'});
    databaseReference
        .child('flutterDevsTeam3')
        .update({'description': 'Senior Software Engineer'});
  }

  void deleteData() {
    databaseReference.child('flutterDevsTeam1').remove();
    databaseReference.child('flutterDevsTeam2').remove();
    databaseReference.child('flutterDevsTeam3').remove();
  }
}

class User {
  String name;

  User({this.name});
}
