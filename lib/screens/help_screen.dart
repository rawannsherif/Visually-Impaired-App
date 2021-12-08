import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/screens/home_design_course.dart';
import 'package:best_flutter_ui_templates/screens/index.dart';
import 'package:best_flutter_ui_templates/screens/settings.dart';
import 'package:best_flutter_ui_templates/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';

import 'ChatScreen.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool _Listening = false;
  stt.SpeechToText _speech = stt.SpeechToText();
  VoiceController _voiceController;
  String _command;

  void _comm() async {
    _Listening = false;
    if (!_Listening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onState: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _Listening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _command = val.recognizedWords;
            _givecommand(_command);
          }),
        );
      } else {
        setState(() => _Listening = false);
        await _speech.stop();
      }
    }
  }

  void _givecommand(_command) {
    if (_command == "home") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DesignCourseHomeScreen()),
        );
      });
    } else if (_command == "settings") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        );
      });
    } else if (_command == "sign out") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyindexApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress: () {
          _comm();
        },
        child: Container(
          color: AppTheme.nearlyWhite,
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: AppTheme.nearlyWhite,
              body: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: 16,
                        right: 16),
                    child: Image.asset('assets/images/helpImage.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'How can we help you?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: const Text(
                      'It looks like you are experiencing problems\nwith our sign up process. We are here to\nhelp so please get in touch with us',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  offset: const Offset(4, 4),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Chat with Us',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () => _chat(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void _chat() {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new ChatPage()));
    this.setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => testWidget,
        ),
      );
    });
  }
}
