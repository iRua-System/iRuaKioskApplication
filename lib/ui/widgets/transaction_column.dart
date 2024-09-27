import 'package:flutter/material.dart';
import 'package:kiosk/ui/widgets/helper.dart';

class TransactionColumn extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function()? onTap;
  final String price;
  final String status;
  final double width;
  TransactionColumn(
      {required this.price,
      required this.title,
      this.subtitle,
      this.onTap,
      required this.status,
      required this.width});
  @override
  Widget build(BuildContext context) {
    String text = "";
    if (status == "Checkin") {
      text = "Waiting";
    } else if (status == "Working") {
      text = "Working";
    } else if (status == "Cancel") {
      text = "Cancelled";
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(20),
              // boxShadow: [
              //   BoxShadow(
              //     //offset: Offset(0, 4),
              //     blurRadius: 0.5,
              //   )
              // ]
              // border: Border.all(color: Colors.grey[900], width: 1),
            ),
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width * 0.28,
                  child: Text(
                    title.toUpperCase(),
                    style: TextStyle(
                        fontSize: 23.0,
                        //fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                Spacer(),
                Text(
                  MoneyFormat.formatMoney(price.split(".")[0]),
                  style: TextStyle(
                      fontSize: 23.0,
                      //fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 23.0,
                        //fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
