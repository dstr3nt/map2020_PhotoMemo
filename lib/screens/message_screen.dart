import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/message.dart';
import 'package:photomemo/screens/sendmessage_screen.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/home/messageScreen';

  @override
  State<StatefulWidget> createState() {
    return _MessageState();
  }
}

class _MessageState extends State<MessageScreen> {
  _Controller con;
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
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg['user'];
    messages ??= arg['messageList'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Message Board'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_comment_outlined),
            onPressed: con.sendMessage,
          ),
        ],
      ),
      body: messages.length == 0
          ? Text(
              'No Messages',
              style: TextStyle(fontSize: 30.0),
            )
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) => Card(
                margin: EdgeInsets.all(10.0),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text('From : ${messages[index].createdBy}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('subject : ${messages[index].title}'),
                      Center(child: Text(messages[index].message)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _Controller {
  _MessageState _state;
  _Controller(this._state);

  void sendMessage() async {
    try {
      List<Message> messages =
          await FirebaseController.getMessagesSentToMe(_state.user.email);

      await Navigator.pushNamed(
        _state.context,
        SendMessageScreen.routeName,
        arguments: {
          'user': _state.user,
          'messageList': messages,
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
