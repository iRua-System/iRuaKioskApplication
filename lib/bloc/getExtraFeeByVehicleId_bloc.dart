import 'dart:async';

import 'package:kiosk/dataprovider/getExtraFeeByVehicleId.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetExtraFeeBloc {
 
  StreamController getExtraFeeStream = new StreamController.broadcast();
 
  Stream get getExtraFee => getExtraFeeStream.stream.asBroadcastStream();

  Future<bool> getExtraFeeBloc(context, vehicleId) async {
    print("Bloc Check");
    var getExtra = GetExtraFeeByVehicleIdProvider();
    var result =
        await getExtra.getExtraFeeByVehicleProvider(vehicleId).catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    print(result);
    if (result != null) {
      getExtraFeeStream.sink.add(result);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    getExtraFeeStream.close();
  }
}
