import 'package:flutter/material.dart';

class SendMessageScreen extends StatefulWidget {
  static const routeName = '/home/MessageScreen/SendMessageScreen';
  @override
  State<StatefulWidget> createState() {
    return _SendMessageState();
  }
}

class _SendMessageState extends State<SendMessageScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: con.send,
          ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Send to who?'),
                autocorrect: false,
                validator: con.validatorSendTo,
                onSaved: con.onSavedSendTo,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
                autocorrect: true,
                validator: con.validatorTitle,
                onSaved: con.validatorTitle,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Message',
                ),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 13,
                validator: con.validatorMessage,
                onSaved: con.onSavedMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SendMessageState _state;
  _Controller(this._state);
  String title;
  String message;

  void send() {}

  String validatorSendTo(String value) {
    if (value.contains('@') && value.contains('.')) {
      return 'Valid Email Required';
    } else {
      return null;
    }
  }

  void onSavedSendTo(String value) {
    this.title = value;
  }

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 1) {
      return 'min 1 chars';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    this.title = value;
  }

  String validatorMessage(String value) {
    if (value == null || value.trim().length < 1) {
      return 'min 1 chars';
    } else {
      return null;
    }
  }

  void onSavedMessage(String value) {
    this.message = value;
  }
}
