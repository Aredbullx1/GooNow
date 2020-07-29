import '../screens/menu_dashboard_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import '../utils/universal_variables.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../utils/delayed_animation.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthMethods _authMethods = AuthMethods();
  bool isLoginPressed = false;

  double screenWidth, screenHeight;
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    final color = Colors.white;
    _scale = 1 - _controller.value;
    return MaterialApp(
      title: 'GooNow',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.4,
                child: AvatarGlow(
                  endRadius: 90,
                  duration: Duration(seconds: 2),
                  glowColor: Colors.white24,
                  repeat: true,
                  repeatPauseDuration: Duration(seconds: 2),
                  startDelay: Duration(seconds: 1),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: UniversalVariables.blackColor,
                      child: SizedBox(
                        child: Image.asset(
                          'lib/assets/launcher/iOS-icon.png',
                        ),
                      ),
                      radius: 50.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
                child: DelayedAnimation(
                  child: Text(
                    "Bienvenidos a",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: color),
                  ),
                  delay: delayedAmount + 1000,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
                child: DelayedAnimation(
                  child: Text(
                    "GooNow",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: color),
                  ),
                  delay: delayedAmount + 2000,
                ),
              ),
              SizedBox(
                height: 0.0,
              ),
              SizedBox(
                height: screenHeight * 0.1,
                child: DelayedAnimation(
                  child: Text(
                    "Tu app de videollamadas",
                    style: TextStyle(fontSize: 20.0, color: color),
                  ),
                  delay: delayedAmount + 3000,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
                child: DelayedAnimation(
                  child: Text(
                    "",
                  ),
                  delay: delayedAmount + 0,
                ),
              ),
              SizedBox(
                height: 0.0,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI,
                  ),
                ),
                delay: delayedAmount + 4000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            'INICIAR SESIÓN',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: UniversalVariables.lightBlueColor,
            ),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    performLogin();
  }

  void performLogin() {
    debugPrint("tring to perform login");

    setState(() {
      isLoginPressed = true;
    });

    _authMethods.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        debugPrint("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MenuDashboardPage();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MenuDashboardPage();
        }));
      }
    });
  }
}
