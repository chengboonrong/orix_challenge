import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String num1;
  String num2;
  String num3;
  double score;

  User({this.name, this.num1, this.num2, this.num3, this.score});

  final databaseReference = FirebaseDatabase.instance.reference();

  Future readData() async {
    var users = List();

    await databaseReference.once().then((DataSnapshot snapshot) {
      if (snapshot.value['users'] != null) {
        // print(snapshot.value);
        snapshot.value['users'].forEach((k, v) => users.add(v));
        // print(v['name']));
      }
    });
    return users;
  }
}
