import '../../../utils/universal_variables.dart';
import 'package:flutter/material.dart';
import '../../../models/call.dart';
import '../../../resources/call_methods.dart';
import '../../../screens/callscreens/call_screen.dart';
import '../../../screens/chatscreens/widgets/cached_image.dart';
import '../../../utils/permissions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    @required this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blueColor,
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Llamada entrante...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            CachedImage(
              call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 15),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(call: call),
                            ),
                          )
                        : {};
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
