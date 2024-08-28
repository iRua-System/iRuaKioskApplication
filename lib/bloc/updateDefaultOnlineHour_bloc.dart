import 'dart:async';

import 'package:kiosk/dataprovider/updateDefaultOnlineHour.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UpdateDefaultOnlineHourBloc {
  StreamController updateDefaultOnlineHourStream = new StreamController();
  Stream get updateDefaultOnlineHour => updateDefaultOnlineHourStream.stream;

  Future<bool> updateDefaultOnlineHourBloc(
      context, String start, end, limitedSlot) async {
    print("Bloc Check");
    var update = UpdateDefaultOnlineHourProvider();
    var result = await update
        .updateDeafultOnlineHour(start, end, limitedSlot)
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result) {
      print(result);
      OpenDialog.displayDialog(
          "Success", context, "Update Succeeded", AlertType.success);
      // Navigator.of(context).popUntil((route) => count++ >= 2);

      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Update Unsucceeded", AlertType.error);
      return false;
    }
  }

  void dispose() {
    updateDefaultOnlineHourStream.close();
  }
}
