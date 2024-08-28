import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kiosk/dataprovider/checkBookedCustomer.dart';
import 'package:kiosk/dataprovider/checkMember.dart';
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/ui/booking/member/booked/getBookedInfo.dart';
import 'package:kiosk/ui/booking/member/unbooked/getWalkinInfo.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckBookedCustomerBloc {
  StreamController checkBookedCustomerStream = new StreamController();
  StreamController isLoggingStream = new StreamController();
  Stream get isLogging => isLoggingStream.stream;
  Stream get checkMember => checkBookedCustomerStream.stream;

  Future<bool> checkBookedMember(context, String phoneNum, bool booked) async {
    isLoggingStream.sink.add("Logging");
    print("Bloc Check");
    var checkProvider = CheckBookedCustomerProvider();
    Customer temp = Customer(deviceToken: '');
    var result =
        await checkProvider.checkBookedCustomer(phoneNum).catchError((error) {
      OpenDialog.displayDialog(
          "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
      isLoggingStream.sink.add("Done");
    });
    if (result != null) {
      isLoggingStream.sink.add("Done");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GetBookedInfo(
                transaction: result,
              )));
      return true;
    } else {
      // OpenDialog.displayDialog(
      //     "Error", context, "Người dùng chưa đặt lịch", AlertType.error);
      // isLoggingStream.sink.add("Done");
      // return false;
      var checkProvider = CheckMemberProvider();
      temp = await checkProvider.checkMember(phoneNum).catchError((error) {
        OpenDialog.displayDialog(
            "Error", context, "Kiểm tra lại kết nối mạng", AlertType.error);
      });
      isLoggingStream.sink.add("Done");
      if (temp != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GetWalkinInfo(
                  phoneNum: phoneNum,
                  cust: temp,
                )));
        isLoggingStream.sink.add("Done");
        return true;
      }
      ;
    }
    return false;
  }

  void dispose() {
    isLoggingStream.close();
    checkBookedCustomerStream.close();
  }
}
