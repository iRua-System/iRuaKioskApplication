import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/removeServices.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RemoveServicesBloc {
  StreamController removeServices = new StreamController();
  Stream get removeServicesStream => removeServices.stream;

  Future<bool> removeServicesBloc(
      context, String transId, String servicesVehicleId) async {
    print("Bloc Check");
    var removeServiceProvider = RemoveServiceProvider();
    var result = await removeServiceProvider
        .removeService(transId, servicesVehicleId)
        .catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    Navigator.of(context).pop();
    if (result) {
      print(result);
      //Navigator.of(context).pop();
      // Navigator.of(context).popUntil((route) => count++ >= 2);
     
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    removeServices.close();
  }
}
