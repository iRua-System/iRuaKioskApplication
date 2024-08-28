import 'dart:async';


import 'package:kiosk/dataprovider/getServices.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetServicesBloc {
  StreamController getServicesStream = new StreamController.broadcast();
  Stream get getServices => getServicesStream.stream.asBroadcastStream();

  Future<bool> getServicesBloc(
      context, String vehicleTypeId, List<Service> services) async {
    print("Bloc Check");
    var getServices = GetServicesProvider();
    var result = await getServices
        .getServices(vehicleTypeId, services)
        .catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    if (result!.length > 0) {
      getServicesStream.sink.add(result);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    getServicesStream.close();
  }
}
