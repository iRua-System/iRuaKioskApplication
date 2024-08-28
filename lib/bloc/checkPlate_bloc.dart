import 'dart:async';


import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/checkPlate.dart';
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/ui/booking/member/unbooked/getWalkinService.dart';
import 'package:kiosk/ui/widgets/confirmDialog.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CheckPlateBloc {
  StreamController checkPlateStream = new StreamController.broadcast();
  Stream get checkPlate => checkPlateStream.stream.asBroadcastStream();

  Future<bool> checkPlateBloc(context, String plate, Customer cust, serviceList, vehicleType) async {
    print("Bloc Check");
    var checkPlate = CheckPlateProvider();
    var result = await checkPlate.checkPlate(plate)
        .catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    print(result);
    if (result == "OK") {
      Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GetWalkinService(
                  cust: cust,
                  serviceList: serviceList,
                  vehicleType: vehicleType,
                )));
      return true;
    } else {
      if(result == "Existed"){
         OpenDialog.displayDialog("Thông Báo", context, "Biển số xe đang ở trạng thái chờ rửa hoặc đang rửa",AlertType.error);
      }else if(result =="Blacklisted"){
        ConfirmDialog.displayDialog("Cảnh Báo", context, "Biển số xe này đã vào danh sách đen vì chưa thanh toán giao dịch trước", AlertType.info, cust, vehicleType, serviceList);
      }
      return false;
    }
  }

  void dispose() {
    checkPlateStream.close();
  }
}
