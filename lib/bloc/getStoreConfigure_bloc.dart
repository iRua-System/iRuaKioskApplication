import 'dart:async';

import 'package:intl/intl.dart';
import 'package:kiosk/dataprovider/getStoreConfigure.dart';
import 'package:kiosk/dataprovider/getSystemTime.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetConfigureBloc {
  StreamController getConfigureStream = new StreamController.broadcast();
  StreamController systemStream = new StreamController.broadcast();
  Stream get getConfigure => getConfigureStream.stream.asBroadcastStream();
  Stream get system => getConfigureStream.stream.asBroadcastStream();

  Future<bool> getConfigureBloc(context) async {
    print("Bloc Check 123");
    var getConfigure = GetStoreConfigureProvider();
    var result = await getConfigure.getStoreConfigure().catchError((error) {
      print(error);
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result != null) {
      getConfigureStream.sink.add(result);
      return true;
    } else {
      getConfigureStream.sink.add("NOSTORE");
      return false;
    }
  }

  void dispose() {
    getConfigureStream.close();
    systemStream.close();
  }

  Future<dynamic> getSystemBloc(context, check) async {
    var system = GetSystemTimeProvider();
    var result = await system.getSystemTimeProvider().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });

    if (result != null) {
      if (check) {
        var date = DateFormat.yMd().add_Hms().parse(result);
        return date;
      } else {
        return result;
      }
    } else {
      //systemStream.sink.add("ERROR");
      return null;
    }
  }
}
