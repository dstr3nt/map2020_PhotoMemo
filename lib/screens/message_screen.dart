import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photomemo/controller/firebasecontroller.dart';
import 'package:photomemo/model/message.dart';
import 'package:photomemo/screens/sendmessage_screen.dart';
import 'package:photomemo/screens/views/mydialog.dart';

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
          con.delIndex == null
              ? IconButton(
                  icon: Icon(Icons.add_comment_outlined),
                  onPressed: con.sendMessage,
                )
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: con.delete,
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
                color: con.delIndex != null && con.delIndex == index
                    ? Colors.red[100]
                    : Colors.white,
                margin: EdgeInsets.all(10.0),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  onTap: () => con.onTap(index),
                  onLongPress: () => con.onLongPress(index),
                  title: Text('From : ${messages[index].createdBy}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('subject : ${messages[index].title}'),
                      Center(
                        child: Text(messages[index].message),
                      ),
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
  int delIndex;
  String passKey;

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
      Navigator.pop(_state.context);
    } catch (e) {
      print(e);
    }
  }

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
  }

  void onTap(int index) async {
    if (delIndex != null) {
      //cancel delete mode
      _state.render(() => delIndex = null);
      return;
    }
  }

  void delete() async {
    try {
      Message message = _state.messages[delIndex];
      await FirebaseController.deleteMessage(message);
      _state.render(() {
        _state.messages.removeAt(delIndex);
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete Message error',
        content: e.message ?? e.toString(),
      );
    }
  }
}
