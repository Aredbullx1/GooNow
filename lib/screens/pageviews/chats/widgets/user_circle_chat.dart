import '../../../../screens/chatscreens/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utils/universal_variables.dart';

class UserCircleC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CachedImage(
                    userProvider.getUser.profilePhoto,
                    radius: 80,
                    isRound: true,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 2),
                  color: UniversalVariables.onlineDotColor),
            ),
          )
        ],
      ),
    );
  }
}
