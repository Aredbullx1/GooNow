import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/user_provider.dart';

class InfoUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: Text(userProvider.getUser.username,
          style: TextStyle(color: Colors.grey[500], fontSize: 14)),
    );
  }
}
