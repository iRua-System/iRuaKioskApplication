import 'package:flutter/material.dart';
import 'package:kiosk/ui/widgets/helper.dart';

class ServiceColumn extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final String price;
  final Icon? icon;
  final Function()? onPressedIcon;
  final String status;
  final bool? isNew;
  ServiceColumn(
      {required this.price,
      required this.title,
      this.onTap,
      this.icon,
      this.onPressedIcon,
      this.isNew,
      required this.status});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 80,
          width: 528,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(0, 4),
                  blurRadius: 7,
                )
              ]),
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 250,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 23.0,
                      //fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Spacer(),
              Container(
                width: 150,
                child: Text(
                  MoneyFormat.formatMoney(price.split(".")[0]),
                  //textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 23.0,
                      //fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Spacer(),
              buildCancelService(
                status,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  buildCancelService(String status) {
    if (title != "Phụ Thu") {
      if (status == "Checkin") {
        return ElevatedButton(
          onPressed: onPressedIcon,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
          child: icon,
        );
      } else if (status == "Working") {
        if (isNew!) {
          return ElevatedButton(
            onPressed: onPressedIcon,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
            ),
            child: icon,
          );
        } else {
          return Container(
            width: 100,
          );
        }
      } else {
        return Container(
          width: 100,
        );
      }
    } else {
      return ElevatedButton(
        onPressed: onPressedIcon,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
        ),
        child: icon,
      );
    }
  }
}
