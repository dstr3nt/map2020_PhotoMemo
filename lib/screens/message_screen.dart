import 'package:flutter/material.dart';
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
        title: Text('Message Board'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_comment_outlined),
            onPressed: con.sendMessage,
          ),
        ],
      ),
      body: Text('Messages'),
    );
  }
}

class _Controller {
  _MessageState _state;
  _Controller(this._state);

  void sendMessage() {
    Navigator.pushNamed(_state.context, SendMessageScreen.routeName);
  }
}
