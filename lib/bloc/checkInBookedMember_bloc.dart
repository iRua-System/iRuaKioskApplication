import 'dart:async';


import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/checkInBookedMember.dart';
import 'package:kiosk/noti/noti.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogToHome.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckInBookedMemberBloc {
  StreamController checkInBookedMember = new StreamController();
  StreamController isChecking = new StreamController();
  Stream get checkInBookedMemberStream => checkInBookedMember.stream;
  Stream get isCheckingStream => isChecking.stream;

  Future<bool> checkInBookedMemberBloc(
      context, String transId, serialNumNfc, vehiclePlate, vehicleBrand) async {
    isChecking.sink.add("Checking");
    print("Bloc Check");
    PushNoti noti = PushNoti();
    var checkProvider = CheckInBookedMeberProvider();
    var result = await checkProvider
        .checkInBookedMember(transId, serialNumNfc, vehiclePlate, vehicleBrand)
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    print("ket qua " + result.toString());
    Navigator.of(context).pop();
    if (result) {
      noti.updateNoti();
      print(result);
      ToHomeDialog.displayDialog("Success", context,
          "Check in thành công",AlertType.success);
      isChecking.sink.add("Done");
      // Future.delayed(const Duration(seconds: 5), () {
      //   Navigator.of(context).popUntil((route) => route.isFirst);
      // });
      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Check in không thành công", AlertType.error);
      print("alo");
      isChecking.sink.add("Done");
      return false;
    }
  }

  void dispose() {
    isChecking.close();
    checkInBookedMember.close();
  }
}
