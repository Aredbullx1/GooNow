import '../models/user.dart';
import '../provider/user_provider.dart';
import '../resources/auth_methods.dart';
import '../screens/callscreens/pickup/pickup_layout.dart';
import '../screens/login_screen.dart';
import '../screens/pageviews/widgets/user_circle_menu.dart';
import '../screens/pageviews/widgets/user_circle_chat.dart';
import '../screens/pageviews/widgets/user_info.dart';
import '../utils/universal_variables.dart';
import '../widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

final Color backgroundColor1 = UniversalVariables.blueColor;
final Color backgroundColor2 = UniversalVariables.blackColor;

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  final AuthMethods _authMethods = AuthMethods();

  User sender;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    _authMethods.getCurrentUser().then((FirebaseUser user) {
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl,
        );
      });
    });
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: backgroundColor1,
        body: Stack(
          children: <Widget>[
            menu(context),
            dashboard(context),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    singOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();

      if (isLoggedOut) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 80.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 49.0),
                  child: UserCircleM(),
                ),
                SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.54),
                  child: Text(sender.name.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 26)),
                ),
                SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.54),
                  child: InfoUser(),
                ),
                SizedBox(height: screenHeight * 0.35),
                Container(
                  margin: EdgeInsets.only(left: screenWidth * 0.08),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: FlatButton(
                    onPressed: () => singOut(),
                    child: Text(
                      "CERRAR SESIÓN",
                      style: TextStyle(
                          color: UniversalVariables.lightBlueColor,
                          fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: isCollapsed
              ? BorderRadius.all(Radius.circular(0))
              : BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: backgroundColor2,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
            child: Container(
              padding: isCollapsed
                  ? const EdgeInsets.only(top: 0)
                  : const EdgeInsets.only(top: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height:
                        isCollapsed ? screenHeight * 0.12 : screenHeight * 0.12,
                    child: CustomAppBar(
                      leading: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                      title: UserCircleC(),
                      centerTitle: true,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height:
                        isCollapsed ? screenHeight * 0.88 : screenHeight * 0.75,
                    child: HomeScreen(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
