import 'dart:async';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:app_settings/app_settings.dart';
import 'package:best_flutter_ui_templates/screens/home_design_course.dart';
import 'package:best_flutter_ui_templates/screens/index.dart';
import 'package:best_flutter_ui_templates/screens/sign_in_screen.dart';

import 'package:flutter/material.dart';

import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';

import 'help_screen.dart';

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    initPlatformState();
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
    if (_command == "help") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HelpScreen(),
          ),
        );
      });
    } else if (_command == "home") {
      this.setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DesignCourseHomeScreen()),
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

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: DesignCourseAppTheme.nearlyBlue //change your color here
            ),
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
        title: Text(
          'Settings',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.27,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: AppTheme.white,
      body: ListView(
        padding: const EdgeInsets.only(top: 8, left: 10),
        children: <Widget>[
          GestureDetector(
            onLongPress: () {
              _comm();
            },
            child: Row(
              children: [
                Icon(Icons.security),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Security',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openSecuritySettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(Icons.settings_applications),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Application settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openAppSettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(Icons.settings_display),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Display',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openDisplaySettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(Icons.notifications),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Notifications',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openNotificationSettings();
            },
          ),
          GestureDetector(
            child: Row(
              children: [
                Icon(Icons.volume_up),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Sound',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              AppSettings.openSoundSettings();
            },
          ),
        ],
      ),
    );
  }

  /// Dispose method to close out and cleanup objects.
  @override
  void dispose() {
    super.dispose();
  }
}
