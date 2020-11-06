// Future<List<Application>> readData() async {
//   var applications = List<Application>();

//   await databaseReference.once().then((DataSnapshot snapshot) {
//     snapshot.value['application'].forEach((k, v) {
//       _users.add(User(
//         name: v['name'],
//         num1: v['num1'],
//         num2: v['num2'],
//         num3: v['num3'],
//         score: v['score'],
//       ));
//       // print(v);
//     });
//   });
//   return users;
// }

// Firebase Realtime Database CRUD functions
// void createData() {
//     databaseReference
//         .child("users/0")
//         .set({'name': 'Deepak Nishad', 'description': 'Team Lead'});
//     databaseReference.child("users/1").set(
//         {'name': 'Yashwant Kumar', 'description': 'Senior Software Engineer'});
//     databaseReference
//         .child("users/2")
//         .set({'name': 'Akshay', 'description': 'Software Engineer'});
//     databaseReference
//         .child("users/3")
//         .set({'name': 'Aditya', 'description': 'Software Engineer'});
//     databaseReference
//         .child("users/4")
//         .set({'name': 'Shaiq', 'description': 'Associate Software Engineer'});
//     databaseReference
//         .child("users/5")
//         .set({'name': 'Mohit', 'description': 'Associate Software Engineer'});
//     databaseReference
//         .child("users/6")
//         .set({'name': 'Naveen', 'description': 'Associate Software Engineer'});
//   }

//   void readData() {
//     databaseReference.once().then((DataSnapshot snapshot) {
//       snapshot.value['users'].forEach((k, v) {
//         print(v);
//       });
//     });
//   }

//   void updateData() {
//     databaseReference.child('flutterDevsTeam1').update({'description': 'CEO'});
//     databaseReference
//         .child('flutterDevsTeam2')
//         .update({'description': 'Team Lead'});
//     databaseReference
//         .child('flutterDevsTeam3')
//         .update({'description': 'Senior Software Engineer'});
//   }

//   void deleteData() {
//     databaseReference.child('flutterDevsTeam1').remove();
//     databaseReference.child('flutterDevsTeam2').remove();
//     databaseReference.child('flutterDevsTeam3').remove();
//   }
// }
