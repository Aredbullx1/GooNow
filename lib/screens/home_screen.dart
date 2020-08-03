import 'package:GooNow/screens/pageviews/logs/log_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../enum/user_state.dart';
import '../provider/user_provider.dart';
import '../resources/auth_methods.dart';
import '../screens/callscreens/pickup/pickup_layout.dart';
import 'pageviews/chats/chat_list_screen.dart';
import '../utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  final AuthMethods _authMethods = AuthMethods();
  int _page = 0;

  final ChatListScreen _chatScreen = ChatListScreen();
  final LogScreen _logScreen = LogScreen();

  Widget _showPage = new ChatListScreen();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _chatScreen;
        break;
      case 1:
        return _logScreen;
        break;
      default:
        return new Container(
          child: new Center(
            child: new Text('Página no encontrada'),
          ),
        );
    }
  }

  UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : debugPrint("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : debugPrint("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : debugPrint("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : debugPrint("detached state");
        break;
    }
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        bottomNavigationBar: CurvedNavigationBar(
          index: _page,
          backgroundColor: UniversalVariables.blackColor,
          buttonBackgroundColor: UniversalVariables.lightBlueColor,
          color: Colors.transparent,
          items: <Widget>[
            Icon(Icons.chat, color: Colors.white, size: 30),
            Icon(Icons.call, color: Colors.white, size: 30)
          ],
          onTap: (int tappedIndex) {
            setState(() {
              _showPage = _pageChooser(tappedIndex);
            });
          },
        ),
        body: PageView(
          children: <Widget>[
            Container(
              child: _showPage,
            ),
          ],
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
