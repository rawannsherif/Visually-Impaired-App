import 'package:best_flutter_ui_templates/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

class AdminPage extends StatefulWidget {
  final SharedPreferences prefs;
  final String chatId;
  final String title;
  static const routeName = "/adminchat";
  AdminPage({this.prefs, this.chatId, this.title});
  @override
  AdminPageState createState() {
    return new AdminPageState();
  }
}

class AdminPageState extends State<AdminPage> {
  final db = FirebaseFirestore.instance;
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;

  @override
  void initState() {
    super.initState();
    /*chatReference =
        db.collection("chats").doc(widget.chatId).collection('messages');*/
    chatReference = db.collection("messages");
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
                margin:
                    const EdgeInsets.only(left: 85.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: DesignCourseAppTheme.nearlyBlue,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(24.0))),
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        documentSnapshot.data()['text'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.nearlyWhite),
                      ),
                    ))),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 8.0),
          )
        ],
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 8.0),
          ),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                margin:
                    const EdgeInsets.only(right: 85.0, top: 10.0, bottom: 10.0),
                decoration: BoxDecoration(
                    color: DesignCourseAppTheme.nearlyBlue,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(24.0))),
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        documentSnapshot.data()['text'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: DesignCourseAppTheme.nearlyWhite),
                      ),
                    ))),
          ],
        ),
      ),
    ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs
        .map<Widget>((doc) => Container(
              child: new Row(
                  children: doc.data()['sender_id'] == 1
                      ? generateReceiverLayout(doc)
                      : generateSenderLayout(doc)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final usersData = Provider.of<Users>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User"),
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: new Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream:
                  chatReference.orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text("No Chat");
                return Expanded(
                  child: new ListView(
                      reverse: true, children: generateMessages(snapshot)),
                );
              },
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
            new Builder(builder: (BuildContext context) {
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isWritting ? () => _sendText(_textController.text) : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isWritting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.length > 0;
                    });
                  },
                  onSubmitted: _sendText,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference.add({
      'text': text,
      'reciever_id': 1,
      'time': FieldValue.serverTimestamp(),
      'sender_id': 2,
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }
}
