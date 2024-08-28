import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosk/bloc/checkInBookedMember_bloc.dart';
import 'package:kiosk/dataprovider/checkPlate.dart';

import 'package:kiosk/models/transaction.dart';

import 'package:kiosk/ui/widgets/confirmDialogOnline.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CheckPlateOnlineBloc {
  StreamController checkPlateOnlineStream = new StreamController.broadcast();
  Stream get checkPlateOnline => checkPlateOnlineStream.stream.asBroadcastStream();
  CheckInBookedMemberBloc bloc = CheckInBookedMemberBloc();

  Future<bool> checkPlateOnlineBloc(context, String plate, String transactionId, nfc,vehicleBrand) async {
    print("Bloc Check");
    var checkPlate = CheckPlateProvider();
    
    var result = await checkPlate.checkPlate(plate)
        .catchError((error) {
      OpenDialog.displayDialog("Error", context, "Kiểm tra lại kết nối mạng",AlertType.error);
    });
    print(result);
    if (result == "OK") {
      bloc.checkInBookedMemberBloc(
        context, transactionId, nfc, plate, vehicleBrand);
        return true;
    } else {
      if(result == "Existed"){
         Navigator.of(context).pop();
         OpenDialog.displayDialog("Error", context, "Biển số xe đang ở trạng thái chờ rửa hoặc đang rửa",AlertType.error);
         return false;
      }else if(result =="Blacklisted"){
        Navigator.of(context).pop();
        ConfirmDialogOnline.displayDialog("Error", context, "Biển số xe này đã vào danh sách đen vì chưa thanh toán giao dịch trước", AlertType.info,
        bloc.checkInBookedMemberBloc(
        context, transactionId, nfc, plate, vehicleBrand));
      }
      return false;
    }
  }

  void dispose() {
    checkPlateOnlineStream.close();
  }
}
