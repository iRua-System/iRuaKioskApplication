import 'dart:async';


import 'package:kiosk/dataprovider/checkAdmin.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckAdminBloc {
  StreamController checkAdminStream = new StreamController.broadcast();
  Stream get checkAdmin => checkAdminStream.stream.asBroadcastStream();

  Future<bool> checkAdminBloc(context, String password) async {
    print("Bloc Check");
    var checkAd = CheckAdminProvider();
    var result = await checkAd
        .checkAdmin(password)
        .catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    checkAdminStream.close();
  }
}
