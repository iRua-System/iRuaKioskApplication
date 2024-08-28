import 'dart:async';
import 'package:kiosk/dataprovider/updateServicePrice.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogCount.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UpdateServicesPriceBloc {
  StreamController updateServicePriceStream = new StreamController();
  StreamController isCheckingStream = new StreamController();
  Stream get updateServicePrice => updateServicePriceStream.stream;
  Stream get isChecking => isCheckingStream.stream;

  Future<bool> updateServicePriceBloc(
      String serviceVehicleId, price, bool isActive, context) async {
    isCheckingStream.sink.add("Checking");
    print("Bloc Check");
    var updateProvider = UpdateServicePriceProvider();

    var result = await updateProvider
        .updateServicePriceProvider(serviceVehicleId, price, isActive)
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result) {
      if (isActive) {
        CountDialog.displayDialog(
            "Success", context, "Update Succeeded", AlertType.success, 2);
        isCheckingStream.sink.add("Done");
        return true;
      } else {
        OpenDialog.displayDialog(
            "Success", context, "Delete Succeeded", AlertType.success);
        isCheckingStream.sink.add("Done");
        return true;
      }
    } else {
      if (isActive) {
        OpenDialog.displayDialog(
            "Error", context, "Update Unsucceeded", AlertType.error);
        print("alo");
        isCheckingStream.sink.add("Done");
        return false;
      } else {
        OpenDialog.displayDialog(
            "Error", context, "Delete Unsucceeded", AlertType.error);
        print("alo");
        isCheckingStream.sink.add("Done");
        return false;
      }
    }
  }

  void dispose() {
    isCheckingStream.close();
    updateServicePriceStream.close();
  }
}
