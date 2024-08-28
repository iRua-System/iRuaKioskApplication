import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/finishTransaction.dart';
import 'package:kiosk/noti/noti.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:kiosk/ui/widgets/dialogCount.dart';
import 'package:kiosk/ui/widgets/dialogToHome.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FinishTransactionBloc {
  StreamController finishTransaction = new StreamController();
  StreamController isChecking = new StreamController();
  Stream get isCheckingStream => isChecking.stream;
  Stream get finishTransactionStream => finishTransaction.stream;

  Future<bool> finishTransactionBloc(
      context, String paymentsID, payment, transactionId, deviceToken) async {
    isChecking.sink.add("Logging");
    print("Bloc Check");
    var finishProvider = FinishTransactionProvider();
    PushNoti noti = PushNoti();
    var result = await finishProvider
        .finishTransaction(transactionId, paymentsID)
        .catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
      isChecking.sink.add("Done");
    });
    Navigator.of(context).pop();
    if (result == "OK") {
      noti.updateNoti();
      if (payment == "E-wallet" || payment == "Tiền mặt") {
        isChecking.sink.add("Done");
        noti.sendNotiToUser("Bạn vừa hoàn thành 1 đơn hàng", deviceToken);
        CountDialog.displayDialog("Success", context,
            "Hoàn tất giao dịch thành công", AlertType.success,3);
        return true;
      } else {
        isChecking.sink.add("Done");
        CountDialog.displayDialog("Success", context,
            "Thêm vào blacklist thành công", AlertType.success,3);
        return true;
      }
    } else if (result == "Not enough money") {
      OpenDialog.displayDialog("Error", context,
          "Số dư tài khoản trong ví KH không đủ", AlertType.error);
    } else {
      if (payment == "E-wallet" || payment == "Tiền mặt") {
        isChecking.sink.add("Done");
        OpenDialog.displayDialog(
            "Error", context, "Hoàn tất giao dịch thất bại", AlertType.error);
      } else {
        isChecking.sink.add("Done");
        OpenDialog.displayDialog(
            "Error", context, "Thêm vào blacklist thất bại", AlertType.error);
      }
    }

    return false;
  }

  void dispose() {
    finishTransaction.close();
    isChecking.close();
  }
}