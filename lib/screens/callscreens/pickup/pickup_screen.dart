import '../../../constants/strings.dart';
import '../../../models/log.dart';
import '../../../resources/local_db/repository/log_repository.dart';
import '../../../utils/universal_variables.dart';
import 'package:flutter/material.dart';
import '../../../models/call.dart';
import '../../../resources/call_methods.dart';
import '../../../screens/callscreens/call_screen.dart';
import '../../../screens/chatscreens/widgets/cached_image.dart';
import '../../../utils/permissions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  bool isCallMissed = true;

  addToLocalStorage({@required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

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
              widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
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
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    if (await Permissions
                        .cameraAndMicrophonePermissionsGranted()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: widget.call),
                        ),
                      );
                    }
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
