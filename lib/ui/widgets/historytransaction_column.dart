import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/admin/transactionDetails.dart';
import 'package:kiosk/ui/widgets/helper.dart';

class HistoryTransactionColumn extends StatelessWidget {
  final Transaction transaction;
  final double? width;
  HistoryTransactionColumn({required this.transaction, this.width});
  @override
  Widget build(BuildContext context) {
    Color color;
    String status = '';
    final f = new DateFormat('dd-MM-yyyy hh:mm');
    DateTime temp = DateTime.parse(transaction.finishedDate!);
    String date = f.format(temp);
    if (transaction.status == "Finish") {
      if (transaction.payment == "Chưa thanh toán") {
        color = Colors.black;
      } else {
        color = Colors.green;
      }
    } else {
      color = Colors.red;
    }

    if (transaction.status == "Finish") {
      status = "Completed";
    }
    if (transaction.status == "Cancel") {
      status = "Cancelled";
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TransactionDetailsScreen(
                  transId: transaction.id!,
                  payment: transaction.payment!,
                  finish: transaction.finishedDate!.split("T")[0],
                  price: transaction.price!)));
        },
        child: Container(
          height: 250,
          width: 528,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
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
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
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
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Transaction ID : ' +
                          transaction.id!.split("-")[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Staff : ",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      transaction.emp!.fullname!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Transaction Status : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Plate : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      transaction.vehiclePlate!,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Total : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "\$" + MoneyFormat.formatMoney(transaction.price!),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Payment Method : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      transaction.payment!,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildRatingStar(String starPoint) {
    if (starPoint == "null") {
      starPoint = "0";
    }
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
