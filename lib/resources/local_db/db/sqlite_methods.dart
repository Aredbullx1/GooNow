import 'package:GooNow/models/log.dart';
import 'package:GooNow/resources/local_db/interface/log_interface.dart';

class SqliteMethods implements LogInterface {
  @override
  addLogs(Log log) {
    print("Añadiendo valores a la BD de Sqlite");
    return null;
  }

  @override
  close() {
    // TODO: implement close
    return null;
  }

  @override
  deleteLogs(int logId) {
    // TODO: implement deleteLogs
    return null;
  }

  @override
  Future<List<Log>> getLogs() {
    // TODO: implement getLogs
    return null;
  }

  @override
  init() {
    print("Base de datos de Sqlite inizializada");
    return null;
  }
}
