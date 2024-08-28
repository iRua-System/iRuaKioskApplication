
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ToHomeDialog {
  static void displayDialog(title, context, error,type) {
    var alertStyle = AlertStyle(
      overlayColor: Colors.black.withOpacity(0.3),
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
      style: alertStyle,
      type: type,
      title: title,
      desc: error,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context).popUntil((route)=> route.isFirst),
          color: Color(0xff20b9f5),
          radius: BorderRadius.circular(10.0),
        ),
      ],
    ).show();
  }
}