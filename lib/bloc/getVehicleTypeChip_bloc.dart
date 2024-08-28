import 'dart:async';

import 'package:kiosk/dataprovider/getServicesOfVehicle.dart';
import 'package:kiosk/models/vehicleType.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetServicesOfVehicleTypeChipBloc {
  StreamController vehicleTypeStream = new StreamController.broadcast();

  Stream get vehicleType => vehicleTypeStream.stream.asBroadcastStream();

  Future<bool> getVehicleTypeChipBloc(context) async {
    print("Bloc Check");
    var getVehicleType = GetServicesOfVehicleProvider();
    var result =
        await getVehicleType.getServicesOfVehicle().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result.length > 0) {
      List<VehicleType> vehicleTypeList = [];
      for (var service in result) {
        var vehicleTypename = service.vehicleName;
        var vehicleTypeId = service.vehicleId;
        if (vehicleTypeList
                .where((element) =>
                    element.name != null &&
                    element.name!.contains(vehicleTypename))
                .toList()
                .length ==
            0) {
          VehicleType type = VehicleType(
            id: vehicleTypeId,
            name: vehicleTypename,
            check: false,
          );
          vehicleTypeList.add(type);
        }
      }
      vehicleTypeStream.sink.add(vehicleTypeList);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    vehicleTypeStream.close();
  }
}
