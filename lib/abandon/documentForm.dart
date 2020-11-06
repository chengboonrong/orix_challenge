// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:uuid/uuid.dart';
// import 'package:my_app/utils/authentication.dart' as Auth;

// class DocumentForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         resizeToAvoidBottomPadding: false,
//         body: form(),
//       ),
//     );
//   }
// }

// final databaseReference = FirebaseDatabase.instance.reference();

// Future createCustomer(
//     String puc,
//     String la,
//     String lt,
//     String nca,
//     String ca,
//     String ta,
//     String cl,
//     String tl,
//     String sc,
//     String re,
//     String net,
//     String rev,
//     String npbt,
//     String npat) async {
//   List<double> doubleList = [
//     double.parse(puc),
//     double.parse(la),
//     double.parse(lt),
//     double.parse(nca),
//     double.parse(ca),
//     double.parse(ta),
//     double.parse(cl),
//     double.parse(tl),
//     double.parse(sc),
//     double.parse(re),
//     double.parse(net),
//     double.parse(rev),
//     double.parse(npbt),
//     double.parse(npat),
//   ];
//   // print(num1);

//   final http.Response response = await http.post(
//     'https://flask-fire-v10-23jjq2lt2q-de.a.run.app/api/v1',
//     headers: {
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: json.encode({
//       'data': doubleList,
//     }),
//   );
//   if (response.statusCode == 200) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     print('Sent!');
//     print(response.body);
//     databaseReference.child("applications/${Uuid().v4()}").set({
//       'name': Auth.googleSignIn.currentUser.displayName,
//       'email': Auth.googleSignIn.currentUser.email,
//       'Paid-up Capital': puc,
//       'Loan Amount': la,
//       'Loan Tenure': lt,
//       'Non-Current Assets': nca,
//       'Current Assets': ca,
//       'Total Assets': ta,
//       'Current Liabilities': cl,
//       'Total Liabilities': tl,
//       'Share Capital': sc,
//       'Retained Earnings': re,
//       'Networth': net,
//       'Revenue': rev,
//       'Net Profit Before Tax': npbt,
//       'Net Profit After Tax': npat,
//       'credit score': json.decode(response.body)['score'],
//     });
//     EasyLoading.showSuccess('Sent successfully!');
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to send request');
//   }
// }

// Widget form() {
//   final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

//   return SingleChildScrollView(
//       child: ConstrainedBox(
//           constraints: BoxConstraints(),
//           child: Padding(
//               padding: const EdgeInsets.all(6),
//               child: Column(children: <Widget>[
//                 FormBuilder(
//                     key: _fbKey,
//                     initialValue: {
//                       'date': DateTime.now(),
//                       'accept_terms': false,
//                     },
//                     autovalidateMode: AutovalidateMode.always,
//                     child: Column(
//                       children: <Widget>[
//                         FormBuilderDateTimePicker(
//                           attribute: "date",
//                           inputType: InputType.date,
//                           format: DateFormat("yyyy-MM-dd"),
//                           decoration:
//                               InputDecoration(labelText: "Appointment Time"),
//                         ),
//                         FormBuilderTextField(
//                           attribute: "paid-up-capital",
//                           decoration:
//                               InputDecoration(labelText: "Paid-up Capital"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             // FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "loan-amount",
//                           decoration: InputDecoration(labelText: "Loan Amount"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "loan-tenure",
//                           decoration: InputDecoration(labelText: "Loan Tenure"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "nca",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Non-Current Assets Difference (Current year - Last year)"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "ca",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Current Assets Difference (Current year - Last year)"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "ta",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Total Assets Difference (Current year - Last year)"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "cl",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Current Liabilities Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "tl",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Total Liabilities Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "sc",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Share Capital Difference (Current year - Last year)"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "re",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Retained Earnings Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "net",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Networth Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "rev",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Revenue Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "npbt",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Net Profit Before Tax Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderTextField(
//                           attribute: "npat",
//                           decoration: InputDecoration(
//                               labelText:
//                                   "Net Profit After Tax Difference (Current year - Last year"),
//                           validators: [
//                             FormBuilderValidators.numeric(),
//                             FormBuilderValidators.max(70),
//                           ],
//                         ),
//                         FormBuilderCheckbox(
//                           attribute: 'accept_terms',
//                           label: Text(
//                               "I have read and agree to the terms and conditions"),
//                           validators: [
//                             FormBuilderValidators.requiredTrue(
//                               errorText:
//                                   "You must accept terms and conditions to continue",
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: <Widget>[
//                             MaterialButton(
//                               child: Text("Submit"),
//                               onPressed: () {
//                                 if (_fbKey.currentState.saveAndValidate()) {
//                                   print(_fbKey.currentState.value);
//                                 }
//                                 createCustomer(
//                                     _fbKey
//                                         .currentState.value['paid-up-capital'],
//                                     _fbKey.currentState.value['loan-amount'],
//                                     _fbKey.currentState.value['loan-tenure'],
//                                     _fbKey.currentState.value['nca'],
//                                     _fbKey.currentState.value['ca'],
//                                     _fbKey.currentState.value['ta'],
//                                     _fbKey.currentState.value['cl'],
//                                     _fbKey.currentState.value['tl'],
//                                     _fbKey.currentState.value['sc'],
//                                     _fbKey.currentState.value['re'],
//                                     _fbKey.currentState.value['net'],
//                                     _fbKey.currentState.value['rev'],
//                                     _fbKey.currentState.value['npbt'],
//                                     _fbKey.currentState.value['npat']);
//                               },
//                             ),
//                             MaterialButton(
//                               child: Text("Reset"),
//                               onPressed: () {
//                                 _fbKey.currentState.reset();
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ))
//               ]))));
// }
