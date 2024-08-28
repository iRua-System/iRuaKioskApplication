import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConfirmDialogOnline {
  static void displayDialog(title, context, error, type, function) {
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
        color: Color(0xff20b9f5),
      ),
    );
    Alert(
      context: context,
      type: AlertType.warning,
      title: title,
      style: alertStyle,
      desc: error,
      buttons: [
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red,
        ),
        DialogButton(
          child: Text(
            "PROCEED",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: function,
          color: Colors.blue,
        )
      ],
    ).show();
  }
}
