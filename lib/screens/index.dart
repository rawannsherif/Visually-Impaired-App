//import 'package:best_flutter_ui_templates/pages/home.dart';
import 'package:flutter/material.dart';
import 'navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';

import 'package:best_flutter_ui_templates/screens/db/database.dart';
import 'package:best_flutter_ui_templates/screens/sign_in_screen.dart';
import 'package:best_flutter_ui_templates/screens/sign_up_screen.dart';
import 'package:best_flutter_ui_templates/services/facenet.service.dart';
import 'package:best_flutter_ui_templates/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/screens/admin_screen.dart';

class MyindexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Services injection
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help!'),
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
        leading: Container(),
      ),
      body: !loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: DesignCourseAppTheme.nearlyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                    ),
                    child: Text(
                      'Sign In',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.27,
                          color: DesignCourseAppTheme.nearlyWhite),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => SignInPage(
                            cameraDescription: cameraDescription,
                          ),
                        ),
                      );
                    },
                  ),
                  RaisedButton(
                    color: DesignCourseAppTheme.nearlyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                    ),
                    child: Text(
                      'Admin',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.27,
                          color: DesignCourseAppTheme.nearlyWhite),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Adminprofile();
                      }));
                    },
                  ),
                  RaisedButton(
                    color: DesignCourseAppTheme.nearlyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                    ),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.27,
                          color: DesignCourseAppTheme.nearlyWhite),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MySignUpPage(
                            cameraDescription: cameraDescription,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  /* RaisedButton(
                    child: Text('Clean DB'),
                    onPressed: () {
                      _dataBaseService.cleanDB();
                    },
                  ),*/
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }
}
