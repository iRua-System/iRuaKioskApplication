import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/dataprovider/checkInWalkinMember.dart';
import 'package:kiosk/noti/noti.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogToHome.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckInWalkinMemberBloc {
  StreamController checkInWalkinMember = new StreamController();
  StreamController isChecking = new StreamController();
  Stream get checkInWalkinMemberStream => checkInWalkinMember.stream;
  Stream get isCheckingStream => isChecking.stream;

  Future<bool> checkInWalkinMemberBloc(
      String fullname,
      serialNumNfc,
      vehiclePlate,
      vehicleBrand,
      phonenum,
      context,
      List<String> servicesVehicle,
      String deviceToken,
      String totalPrice,
      String time) async {
    isChecking.sink.add("Checking");
    print("Bloc Check");
    var checkProvider = CheckInWalkinMeberProvider();
    print("cbi vao noti");
    PushNoti noti = PushNoti();
    print(time);
    var date = DateFormat("HH:mm").parse(time);
    date = date.add(Duration(minutes: 10));
    var min = date.minute.toString();

    if (date.minute.toString().length == 1) {
      min = "0" + date.minute.toString();
    }
    print(date);
    var result = await checkProvider
        .checkInWalkinMember(fullname, serialNumNfc, vehiclePlate, vehicleBrand,
            phonenum, servicesVehicle, totalPrice)
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
    });
    print("ket qua " + result.toString());
    Navigator.of(context).pop();
    if (result != null) {
      noti.updateNoti();
      noti.sendNotiToUser(
          "Bạn vừa Check in thành công 1 đơn hàng ", deviceToken);
      ToHomeDialog.displayDialog(
          "Success",
          context,
          "Order is number " +
              result.split(".")[0].toString() +
              "\n Estimated time to take the order is " +
              date.hour.toString() +
              ":" +
              min,
          AlertType.success);
      isChecking.sink.add("Done");
      // Future.delayed(const Duration(seconds: 5), () {
      //   Navigator.of(context).popUntil((route) => route.isFirst);
      // });
      return true;
    } else {
      print("failed");
      OpenDialog.displayDialog(
          "Error", context, "Check in unsuccess", AlertType.error);
      print("alo");
      isChecking.sink.add("Done");
      return false;
    }
  }

  void dispose() {
    isChecking.close();
    checkInWalkinMember.close();
  }
}
