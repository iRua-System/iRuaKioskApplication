import 'dart:async';

import 'package:kiosk/dataprovider/getServicesOfVehicle.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetServicesOfVehicleTypeBloc {
  StreamController getServicesOfVehicleTypeStream =
      new StreamController.broadcast();
  StreamController vehicleTypeStream = new StreamController.broadcast();
  StreamController vehicleBrandStream = new StreamController.broadcast();
  Stream get vehicleType => vehicleTypeStream.stream.asBroadcastStream();
  Stream get vehicleBrand => vehicleBrandStream.stream.asBroadcastStream();
  Stream get getServicesOfVehicleType =>
      getServicesOfVehicleTypeStream.stream.asBroadcastStream();

  Future<bool> getVehicleTypeBloc(context) async {
    print("Nguyen check");
    var getVehicleType = GetServicesOfVehicleProvider();
    var result =
        await getVehicleType.getServicesOfVehicle().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    print(result);
    if (result.length > 0) {
      List<String> vehicleTypeList = [];
      for (var service in result) {
        var vehicleType = service.vehicleId! + "." + service.vehicleName;
        if (!vehicleTypeList.contains(vehicleType)) {
          vehicleTypeList.add(vehicleType);
        }
      }
      vehicleTypeStream.sink.add(vehicleTypeList);
      getServicesOfVehicleTypeStream.sink.add(result);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getVehicleBrandBloc(context, String vehicleType) async {
    if (vehicleType != "" && vehicleType != null) {
      print("Bloc check");
      var getVehicleType = GetServicesOfVehicleProvider();
      var result = await getVehicleType.getVehicleBrand().catchError((error) {
        OpenDialog.displayDialog(
            "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
      });

      if (result.length > 0) {
        for (var vehicle in result) {
          if (vehicle.name == vehicleType) {
            vehicleBrandStream.sink.add(vehicle.brand);
            return true;
          }
        }
      } else {
        return false;
      }
    }
    return false;
  }

  void dispose() {
    vehicleTypeStream.close();
    getServicesOfVehicleTypeStream.close();
    vehicleBrandStream.close();
  }
}
