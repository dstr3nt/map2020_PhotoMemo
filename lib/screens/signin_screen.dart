import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/screens/views/mydialog.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset('assets/images/postit.jpg'),
                  Positioned(
                    top: 150.0,
                    left: 110.0,
                    child: Text(
                      'PhotoMemo',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 35.0,
                        fontFamily: 'Miniver',
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: con.validatorEmail,
                onSaved: con.onSavedEmail,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                validator: con.validatorPassword,
                onSaved: con.onSavedPassword,
              ),
              RaisedButton(
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                color: Colors.green,
                onPressed: con.signIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState _state;
  _Controller(this._state);
  String email;
  String password;

  void signIn() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }

    _state.formKey.currentState.save();

    try {
      var user = await FirebaseController.signIn(email, password);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Sign In Error',
        content: e.message ?? e.toString(),
      );
      return;
    }

    //sign in succeeded
    // 1. read all photomemo's from firebase
    // 2. navigate to Home Screen to display photomemo
  }

  String validatorEmail(String value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'Invaild Email Address';
    } else {
      return null;
    }
  }

  void onSavedEmail(String value) {
    email = value;
  }

  String validatorPassword(String value) {
    if (value == null || value.length < 6) {
      return 'Password MIN 6 Chars';
    } else {
      return null;
    }
  }

  void onSavedPassword(String value) {
    password = value;
  }
}
