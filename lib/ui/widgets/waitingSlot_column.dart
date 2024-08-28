import 'package:flutter/material.dart';

class WaitingSlotColumn extends StatelessWidget {
  final String number;
  final String phonenum;
  final double width;
  final Icon icon;
  final Function onPressedIcon;
  WaitingSlotColumn(
      {required this.number, required this.phonenum, required this.width, required this.icon, required this.onPressedIcon});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(1),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text(
                    number,
                    style: TextStyle(
                        fontSize: 23.0,
                        //fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              ),
              Text(
                phonenum,
                style: TextStyle(
                    fontSize: 23.0,
                    //fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              Spacer(),
              // RaisedButton(
              //   onPressed: onPressedIcon,
              //   shape: CircleBorder(),
              //   child: icon,
              // ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
