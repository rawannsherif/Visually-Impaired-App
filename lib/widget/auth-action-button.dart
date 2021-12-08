import 'package:best_flutter_ui_templates/screens/home_design_course.dart';
import 'package:best_flutter_ui_templates/model/users.dart';
import 'package:best_flutter_ui_templates/screens/db/database.dart';
//import 'package:best_flutter_ui_templates/pages/profile.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/screens/navigation_home_screen.dart';
//import '../home.dart';
import 'package:best_flutter_ui_templates/screens/index.dart';
import 'package:provider/provider.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:best_flutter_ui_templates/model/user.dart';

class User {
  String user;
  String password;
  String email;
  String country;
  String birthday;
  String state;

  User(
      {@required this.user,
      @required this.password,
      @required this.email,
      @required this.country,
      @required this.birthday,
      @required this.state});

  static User fromDB(String dbuser) {
    return new User(
        user: dbuser.split(':')[0],
        password: dbuser.split(':')[1],
        email: dbuser,
        country: dbuser,
        birthday: dbuser,
        state: dbuser);
  }
}

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {@required this.onPressed, @required this.isLogin});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  final _ageFocusNode = FocusNode();
  final _fullnameFocusNode = FocusNode();
  String fullname;
  String email;
  String password;
  int age;
  String country;
  String state;
  /*final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  final _countryFocusNode = TextEditingController();
  final _stateFocusNode = FocusNode();
  //final _form = GlobalKey<FormState>();*/
  var _addedUser = Userr(
    userid: null,
    email: '',
    password: '',
    country: '',
    state: '',
  );
  var _initValues = {
    'email': '',
    'password': '',
    'age': '',
    'country': '',
    'fullname': '',
    'state': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    _speech = new stt.SpeechToText();
  }

  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  //stt.SpeechToText _speech;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _validate = false;

  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onState: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {}),
        );
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    }
  }

//compare between innit state de and the one in the comment

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _emailTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _birthdayTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _countryTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _stateTextEditingController =
      TextEditingController(text: '');

  User predictedUser;

  Future _signUp(context) async {
    List predictedData = _faceNetService.predictedData;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;
    String email = _emailTextEditingController.text;
    String birthday = _birthdayTextEditingController.text;
    String country = _countryTextEditingController.text;
    String state = _stateTextEditingController.text;

    /// creates a new user in the 'database'
    await Provider.of<Users>(context, listen: false)
        .addUser(email, password, age, country, fullname, state);
    await _dataBaseService.saveData(
        user, password, predictedData, email, birthday, country, state);

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MyindexApp()));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;

    if (this.predictedUser.password == password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => NavigationHomeScreen()));
    } else {
      print(" WRONG PASSWORD!");
    }
  }

  String _predictUser() {
    String userAndPass = _faceNetService.predict();
    return userAndPass ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: widget.isLogin ? Text('Sign in') : Text('Sign up'),
      icon: Icon(Icons.camera_alt),
      // Provide an onPressed callback.
      onPressed: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = _predictUser();
              if (userAndPass != null) {
                this.predictedUser = User.fromDB(userAndPass);
              }
            }
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
    );
  }

  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 600,
      child: new Form(
          key: _formKey,
          child: Column(
            children: [
              widget.isLogin && predictedUser != null
                  ? Container(
                      child: Text(
                        'Welcome back, ' + predictedUser.user + '! 😄',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : widget.isLogin
                      ? Container(
                          child: Text(
                          'User not found 😞',
                          style: TextStyle(fontSize: 20),
                        ))
                      : Container(),
              widget.isLogin
                  ? Container()
                  : TextFormField(
                      controller: _userTextEditingController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter your Fullname',
                        labelText: 'Fullname',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a valid Name';
                        }
                        if (!RegExp("^[a-zA]").hasMatch(value)) {
                          return 'Please a valid Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        fullname = value;
                        print("fullname is");
                        print(fullname);
                      },
                    ),
              widget.isLogin
                  ? Container()
                  : TextFormField(
                      controller: _emailTextEditingController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.email),
                        hintText: 'Enter a email address',
                        labelText: 'Email',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a valid email address';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'Please a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                        print(email);
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
              widget.isLogin && predictedUser == null
                  ? Container()
                  : TextFormField(
                      controller: _passwordTextEditingController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.lock),
                        hintText: 'Enter a Password',
                        labelText: 'Password',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a valid password';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]").hasMatch(value)) {
                          return 'Please a valid password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        password = value;
                      },
                    ),
              widget.isLogin
                  ? Container()
                  : TextFormField(
                      controller: _countryTextEditingController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.location_on),
                        hintText: 'Enter your country',
                        labelText: 'Country',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a valid Country';
                        }
                        if (!RegExp("^[a-zA]").hasMatch(value)) {
                          return 'Please a valid Country';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        country = value;
                      },
                    ),
              widget.isLogin
                  ? Container()
                  : TextFormField(
                      controller: _stateTextEditingController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.location_city),
                        hintText: 'Enter your state',
                        labelText: 'State',
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a valid State';
                        }
                        if (!RegExp("^[a-zA]").hasMatch(value)) {
                          return 'Please a valid State';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        state = value;
                      },
                    ),
              widget.isLogin && predictedUser != null
                  ? RaisedButton(
                      child: Text('Login'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NavigationHomeScreen();
                          }));
                        }
                        await _signIn(context);
                      },
                    )
                  : !widget.isLogin
                      ? RaisedButton(
                          child: Text('Sign Up!'),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyindexApp();
                              }));
                              await _signUp(context);
                            }
                          },
                        )
                      : Container(),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
