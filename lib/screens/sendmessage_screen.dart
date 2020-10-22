import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/message.dart';
import 'package:photomemo/screens/views/mydialog.dart';

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
  User user;
  List<Message> messages;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    messages ??= args['messageList'];

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
        key: formKey,
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
                onSaved: con.onSavedTitle,
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
  String sentTo;

  String validatorSendTo(String value) {
    if (value == null || !value.contains('@') || !value.contains('.')) {
      return 'Invaild Email Address';
    } else {
      return null;
    }
  }

  void onSavedSendTo(String value) {
    if (value.trim().length != 0) {
      this.sentTo = value;
    }
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

  void send() async {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
    try {
      MyDialog.circularProgreeStart(_state.context);
      var p = Message(
        title: title,
        message: message,
        createdBy: _state.user.email,
        sentTo: sentTo,
      );

      p.docId = await FirebaseController.addMessage(p);
      _state.messages.insert(0, p);
      MyDialog.circularProgressEnd(_state.context);
    } catch (e) {
      MyDialog.circularProgressEnd(_state.context);

      MyDialog.info(
        context: _state.context,
        title: 'Firebase Message Upload Error',
        content: e.message ?? e.toString(),
      );
    }
    Navigator.pop(_state.context);
  }
}
