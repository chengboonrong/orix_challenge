import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/utils/authentication.dart' as GoogleSignIn;

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _email = TextEditingController();

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _email,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        // validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        // onSaved: (value) => this._email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return new Padding(
        padding: const EdgeInsets.only(top: 5, left: 20),
        child: Text(
            'An email will be sent allowing you to reset your password.',
            style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)));
  }

  Widget _submitButton() {
    return FlatButton(
        onPressed: () async {
          await GoogleSignIn.sendResetPassword(_email.text).then((value) {
            if (value == 'success') {
              Fluttertoast.showToast(
                  msg: "Email has been sent!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.of(context).pop(false);
            } else {
              Fluttertoast.showToast(
                  msg: value,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          alignment: Alignment.bottomCenter,
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text('Reset Password'),
        actions: [
          // Icon(Icons.file_upload),
          // Padding(
          // padding: EdgeInsets.symmetric(horizontal: 16),
          // child: Icon(Icons.backspace),
          // ),
          InkWell(
            onTap: () {},
            child: Icon(Icons.more_vert),
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _showEmailInput(),
            _showPasswordInput(),
            _submitButton()
          ],
        ),
      ),
    );
  }
}
