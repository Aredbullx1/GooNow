import '../../../../screens/chatscreens/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utils/universal_variables.dart';

class UserCircleM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxHeight: 120, maxWidth: 120),
              child: Stack(
                children: <Widget>[
                  CachedImage(
                    userProvider.getUser.profilePhoto,
                    radius: 140,
                    isRound: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
