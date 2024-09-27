import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/findTransaction_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/transaction_column.dart';
import 'manageTransactions.dart';

class FindTransactionScreen extends StatefulWidget {
  @override
  _FindTransactionScreen createState() => _FindTransactionScreen();
}

class _FindTransactionScreen extends State<FindTransactionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  FindTransactionBloc bloc = FindTransactionBloc();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus) {
          focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          // Container(
          //     decoration: BoxDecoration(
          //         image: DecorationImage(
          //             image: AssetImage("assets/images/wallpaper1.jpg"),
          //             fit: BoxFit.fill))),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff43ddfb).withOpacity(0.8),
                    Color(0xff20b9f5),
                  ]),
            ),
          ),
          Positioned(
            right: 50,
            top: 5,
            child: Container(
              height: height / 5,
              width: width / 5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/iconwhite.png"))),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: MyBackButton(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Container(
                        width: width / 10,
                        child: Text(
                          'Keyword',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                        height: 60,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 25),
                          //textAlign: TextAlign.right,
                          controller: phoneController,
                          decoration: InputDecoration(
                            //labelText: 'Số điện thoại, biển số xe hay mã đơn hàng',
                            suffixIcon: IconButton(
                                icon: Image.asset("assets/icon/search.png"),
                                onPressed: () {
                                  onFindClicked(context);
                                }),
                            //labelText: 'Số điện thoại',
                            // labelStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff20b9f5), width: 2.0),
                            ),
                          ),
                        )),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  height: height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TransactionHeaderColumn(
                        title: 'Transaction ID',
                        price: 'Total',
                        status: 'Status',
                        width: width,
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                      height: height * 0.65,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: Color(0xff20b9f5).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Column(children: <Widget>[
                        StreamBuilder(
                            stream: bloc.findTransactionStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var snapshotData =
                                    snapshot.data as List<Transaction>;
                                if (snapshotData.length == 0) {
                                  return Center(
                                    child: Text(
                                      'Not found any transaction with that keyword',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ),
                                  );
                                  // } else if (snapshot.data == 'Logging') {
                                  //   return Center(
                                  //     child: CircularProgressIndicator(
                                  //       strokeWidth: 7,
                                  //       backgroundColor:
                                  //           AppColor.PRIMARY_TEXT_WHITE,
                                  //     ),
                                  //   );
                                } else {
                                  return Container(
                                    child: Column(children: <Widget>[
                                      for (var data in snapshotData)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManageTransactions(
                                                          transaction: data,
                                                          phoneNum:
                                                              phoneController
                                                                  .text,
                                                        )))
                                                .then((value) =>
                                                    bloc.findTransactionBloc(
                                                        context,
                                                        phoneController.text));
                                          },
                                          child: TransactionColumn(
                                            width: width,
                                            title: data.id!.split("-")[0],
                                            price: data.price ?? '0',
                                            status: data.status!,
                                          ),
                                        ),
                                    ]),
                                  );
                                }
                              } else {
                                return Container();
                              }
                            }),
                      ]),
                    ))),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void onFindClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    String phoneNum = phoneController.text;
    bloc.findTransactionBloc(context, phoneNum);
    //  Navigator.of(context).push(
    //        MaterialPageRoute(builder: (context) => UnbookedMemberCheckIn(cust:null)));
  }

  void showDialogConfirmActive() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: Text('Processing'),
            content: Container(
              height: 80,
              child: Center(
                child: Column(children: [
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please wait a moment.",
                    style: TextStyle(color: Colors.blueAccent),
                  )
                ]),
              ),
            ),
          );
        });
  }
}

class TransactionHeaderColumn extends StatelessWidget {
  final String title;
  final String price;
  final String status;
  final double width;
  TransactionHeaderColumn(
      {required this.price,
      required this.title,
      required this.status,
      required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: width * 0.9,
      padding: EdgeInsets.only(left: 40, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          Spacer(),
          Text(
            price,
            style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          //Spacer(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              status,
              style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
