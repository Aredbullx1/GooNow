import '../../../screens/callscreens/pickup/pickup_layout.dart';
import '../../../screens/pageviews/logs/widgets/log_list_container.dart';
import '../../../utils/universal_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/floating_column.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        floatingActionButton: FloatingColumn(),
        body: LogListContainer(),
      ),
    );
  }
}
