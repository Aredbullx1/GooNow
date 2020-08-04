import 'package:flutter/material.dart';
import '../../../../utils/universal_variables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/search_screen");
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: UniversalVariables.fabGradient,
            borderRadius: BorderRadius.circular(50)),
        child: Icon(
          Icons.add_comment,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 15, right: 15),
      ),
    );
  }
}
