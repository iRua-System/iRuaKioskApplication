import 'dart:async';

import 'package:kiosk/dataprovider/addServices.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogCount.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddServicesBloc {
  StreamController addServices = new StreamController();
  Stream get addServicesStream => addServices.stream;

  Future<bool> addServicesBloc(
      context, String transId, List<String> servicesVehicle, bool isNew) async {
    print("Bloc Check");
    var addServiceProvider = AddServiceProvider();
    var result = await addServiceProvider
        .addService(transId, servicesVehicle, isNew)
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result) {
      print(result);
      CountDialog.displayDialog(
          "Success", context, "Add services success", AlertType.success, 2);
      // Navigator.of(context).popUntil((route) => count++ >= 2);

      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Add services unsuccess", AlertType.error);
      return false;
    }
  }

  void dispose() {
    addServices.close();
  }
}
