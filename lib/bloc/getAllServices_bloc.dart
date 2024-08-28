import 'dart:async';

import 'package:kiosk/dataprovider/getAllServices.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GetAllServicesBloc {
  StreamController getAllServicesStream = new StreamController.broadcast();
  StreamController getVehicleTypeStream = new StreamController.broadcast();
  StreamController getRemainServicesStream = new StreamController.broadcast();
  Stream get getAllServices => getAllServicesStream.stream.asBroadcastStream();
  Stream get getRemainServices =>
      getRemainServicesStream.stream.asBroadcastStream();
  Stream get getVehicleType => getVehicleTypeStream.stream.asBroadcastStream();
  List<String> list = [];
  List<Service> serviceList = [];
  Future<bool> getAllServicesBloc(context) async {
    print("Bloc Check");
    var getAllServices = GetAllServicesProvider();
    var result = await getAllServices.getAllServices().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result!.length > 0) {
      for (var data in result) {
        for (var vehicle in data.prices) {
          bool check = list
                  .where((element) => element.contains(vehicle.name))
                  .toList()
                  .length >
              0;
          if (!check) {
            list.add(vehicle.name);
          }
        }
      }
      serviceList = result;
      print(list.length);
      getVehicleTypeStream.sink.add(list);
      getAllServicesStream.sink.add(result);
      return true;
    } else {
      getAllServicesStream.sink.add("NOSERVICE");
      return false;
    }
  }

  Future<bool> getRemainServicesBloc(context, List<Service> services) async {
    print("Bloc Check");
    var getAllServices = GetAllServicesProvider();
    List<Service> list = [];
    var result = await getAllServices.getAllServices().catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    if (result!.length > 0) {
      for (var service in result) {
        bool check = services
                .where((element) =>
                    element.name!.contains(service.name as Pattern))
                .toList()
                .length >
            0;
        if (!check) {
          list.add(service);
        }
      }
      getRemainServicesStream.sink.add(list);
      return true;
    } else {
      getAllServicesStream.sink.add("NOSERVICE");
      return false;
    }
  }

  void searchByName(String search) {
    print(search);
    var result =
        serviceList.where((element) => element.name!.contains(search)).toList();
    getAllServicesStream.sink.add(result);
  }

  void dispose() {
    getAllServicesStream.close();
    getVehicleTypeStream.close();
    getRemainServicesStream.close();
  }
}
