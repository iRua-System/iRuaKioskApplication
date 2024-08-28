import 'package:flutter/material.dart';
import 'package:kiosk/noti/globalListener.dart';
import 'package:kiosk/noti/noti.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ApproveDialog {
  static void displayDialog(title, context, error, type) {
    var alertStyle = AlertStyle(
      overlayColor: Colors.black.withOpacity(0.3),
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      animationDuration: Duration(milliseconds: 100),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        fontSize: 20,
        color: Color(0xff20b9f5),
      ),
    );
    isApproveOpen = true;
    Alert(
      style: alertStyle,
      context: context,
      type: AlertType.warning,
      title: title,
      desc: error,
      buttons: [
        DialogButton(
          child: Text(
            "YES",
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            PushNoti noti = PushNoti();
            noti.updateApprove("Đồng ý");
            Navigator.of(context).pop();
            isApproveOpen = false;
          },
          color: Colors.blue,
        ),
        DialogButton(
          child: Text(
            "NO",
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            PushNoti noti = PushNoti();
            noti.updateApprove("Không đồng ý");
            Navigator.of(context).pop();
            isApproveOpen = false;
          },
          color: Colors.red,
        )
      ],
    ).show();
  }
}
