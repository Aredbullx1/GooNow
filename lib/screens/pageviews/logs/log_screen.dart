import 'package:GooNow/models/log.dart';
import 'package:GooNow/resources/local_db/repository/log_repository.dart';
import 'package:GooNow/utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: FlatButton(
          child: Text("Click Me"),
          onPressed: () {
            LogRepository.init(isHive: false);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }
}
