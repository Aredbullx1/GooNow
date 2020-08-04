import '../../../../constants/strings.dart';
import '../../../../models/log.dart';
import '../../../../resources/local_db/repository/log_repository.dart';
import '../../../../screens/chatscreens/widgets/cached_image.dart';
import '../../../../screens/pageviews/chats/widgets/quiet_box.dart';
import '../../../../utils/utilities.dart';
import '../../../../widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i];
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

                return Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: CustomTile(
                    leading: CachedImage(
                      hasDialled ? _log.receiverPic : _log.callerPic,
                      isRound: true,
                      radius: 45,
                    ),
                    mini: false,
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("¿Eliminar este Log?"),
                        content: Text("Estás seguro de eliminar este log?"),
                        actions: [
                          FlatButton(
                            child: Text("SÍ"),
                            onPressed: () async {
                              Navigator.maybePop(context);
                              await LogRepository.deleteLogs(i);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                          FlatButton(
                            child: Text("NO"),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      hasDialled ? _log.receiverName : _log.callerName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    icon: getIcon(_log.callStatus),
                    subtitle: Text(
                      Utils.formatDateString(_log.timestamp),
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return QuietBox(
            heading: "Aquí se lista tu historial de llamadas",
            subtitle: "Llama a personas de todo el mundo con solo un clic",
          );
        }
        return QuietBox(
          heading: "Aquí se lista tu historial de llamadas",
          subtitle: "Llama a personas de todo el mundo con solo un clic",
        );
      },
    );
  }
}
