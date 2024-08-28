import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/models/transaction.dart';

class FeedbackColumn extends StatelessWidget {
  final Transaction transaction;
  final double? width;
  FeedbackColumn({required this.transaction, this.width});

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd-MM-yyyy hh:mm');
    DateTime temp = DateTime.parse(transaction.bookingDate!);
    String date = f.format(temp);
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 250,
          width: 528,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Center(
                      child: Container(
                        height: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.cust!.fullname!,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            buildRatingStar(transaction.feedback!.starPoint!),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Text(date,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Transaction ID : ' +
                          transaction.id!.split("-")[0].toUpperCase(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      "Staff : ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      transaction.emp!.fullname,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  transaction.feedback!.message!,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildRatingStar(String starPoint) {
    List<Widget> widgets = [];
    int i = num.tryParse(starPoint)!.toInt();
    for (int f = 0; f < i; f++) {
      Icon star = Icon(
        Icons.star,
        color: Colors.yellowAccent[700],
        size: 30,
      );
      widgets.add(star);
    }
    int temp = 5 - i;
    for (int f = 0; f < temp; f++) {
      Icon star = Icon(
        Icons.star_border,
        color: Colors.yellowAccent[700],
        size: 30,
      );
      widgets.add(star);
    }
    return Row(
      children: [
        for (var data in widgets) data,
      ],
    );
  }
}
