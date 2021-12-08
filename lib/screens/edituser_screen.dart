import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

import '../model/user.dart';
import '../model/users.dart';
import '../screens/admin_screen.dart';

class EditUserScreen extends StatefulWidget {
  /* @required
  final String id;
  const EditUserScreen({Key key, @required this.id}) : super(key: key);*/

  static const routeName = '/edit-product';

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _ageFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _fullnameFocusNode = FocusNode();
  final _countryFocusNode = TextEditingController();
  final _stateFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedUser = Userr(
    userid: null,
    email: '',
    password: '',
    country: '',
    state: '',
  );
  var _initValues = {
    'email': '',
    'password': '',
    'country': '',
    'state': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final userId = ModalRoute.of(context).settings.arguments as String;
      if (userId != null) {
        _editedUser =
            Provider.of<Users>(context, listen: false).findById(userId);
        _initValues = {
          'email': _editedUser.email,
          'password': _editedUser.password,
          'country': _editedUser.country,

          // 'imageUrl': _editedUser.imageUrl,
          'state': _editedUser.state,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _ageFocusNode.dispose();
    _fullnameFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedUser.userid != null) {
      await Provider.of<Users>(context, listen: false)
          .updateUser(_editedUser.userid, _editedUser);
    } else {
      try {
        //await Provider.of<Users>(context, listen: false).addUser(_editedUser);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit User'),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _form,
              child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    new TextFormField(
                      initialValue: _initValues['email'],
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = Userr(
                          userid: _editedUser.userid,
                          email: value,
                          password: _editedUser.password,
                          country: _editedUser.country,
                          state: _editedUser.state,
                        );
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    new TextFormField(
                      initialValue: _initValues['password'],
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = Userr(
                          userid: _editedUser.userid,
                          email: _editedUser.email,
                          password: value,
                          country: _editedUser.country,
                          state: _editedUser.state,
                        );
                      },
                    ),
                    new TextFormField(
                      initialValue: _initValues['country'],
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.location_on),
                        hintText: 'Enter your country',
                        labelText: 'Country',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Country';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = Userr(
                          userid: _editedUser.userid,
                          email: _editedUser.email,
                          password: _editedUser.password,
                          country: value,
                          state: _editedUser.state,
                        );
                      },
                    ),
                    new TextFormField(
                      initialValue: _initValues['state'],
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.location_city),
                        hintText: 'Enter your state',
                        labelText: 'State',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedUser = Userr(
                          userid: _editedUser.userid,
                          email: _editedUser.email,
                          password: _editedUser.password,
                          country: _editedUser.country,
                          state: value,
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Expanded(
                      child: new Container(
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyBlue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
                          border: Border.all(
                              color: DesignCourseAppTheme.nearlyBlue),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white24,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            onTap: () {
                              if (_form.currentState.validate()) {
                                _saveForm();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Adminprofile();
                                }));
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Processing Data')));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 18, right: 18),
                              child: GestureDetector(
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.27,
                                        color:
                                            DesignCourseAppTheme.nearlyWhite),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
    );
  }
}
