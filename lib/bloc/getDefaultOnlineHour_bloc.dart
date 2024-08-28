import 'dart:async';

import 'package:kiosk/dataprovider/getDefaultOnlineHour.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetDefaultOnlineHourBloc {
  StreamController getDefaultOnlineHourStream = new StreamController.broadcast();
  Stream get getDefaultOnlineHour => getDefaultOnlineHourStream.stream.asBroadcastStream();

  Future<bool> getDefaultConfigureBloc(context) async {
    print("Bloc Check");
    var getDefaultOnlineHour = GetDefaultOnlineHourProvider();
    var result = await getDefaultOnlineHour.getDefaultOnlineHour().catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
   
    if (result != null) {
      getDefaultOnlineHourStream.sink.add(result);
      return true;
    } else {
      getDefaultOnlineHourStream.sink.add("NOHOUR");
      return false;
    }
  }
  
   void dispose() {
    getDefaultOnlineHourStream.close();
  }
}
