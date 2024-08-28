import 'package:flutter/material.dart';
import 'package:kiosk/bloc/getAttendance_bloc.dart';
import 'package:kiosk/ui/booking/member/booked/getBookedNumber.dart';
import 'package:kiosk/ui/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CloseStoreDialog {
  static void displayDialog(title, context, error, type, store) {
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
      style: alertStyle,
      context: context,
      type: AlertType.warning,
      title: title,
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
          onPressed: () {
            GetAttendanceBloc attendanceBloc = GetAttendanceBloc();
            attendanceBloc.getAttendanceBloc(context).then((value) {
              Navigator.of(context).pop();
              if (value) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GetBookedNumberScreen(
                          store: store,
                        )));
              } else {
                OpenDialog.displayDialog(
                    "Error",
                    context,
                    "Currently, no employees have checked in.",
                    AlertType.error);
              }
            });
          },
          color: Colors.blue,
        )
      ],
    ).show();
  }
}
