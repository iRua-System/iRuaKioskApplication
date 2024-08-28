import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/cancelTransaction_bloc.dart';
import 'package:kiosk/bloc/getWaitingList_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/waitingSlot.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/waitingSlot_column.dart';

class WaitingListScreen extends StatefulWidget {
  @override
  _WaitingListScreen createState() => _WaitingListScreen();
}

class _WaitingListScreen extends State<WaitingListScreen> {
  GetWaitingListBloc bloc = GetWaitingListBloc();
  CancelTransactionBloc cancelBloc = CancelTransactionBloc();
  @override
  void initState() {
    bloc.getWaitingListBloc(context);
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  TextEditingController reasonController = TextEditingController();
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
                        width: width / 6,
                        child: Text(
                          'Phone number',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
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
                          onChanged: (value) {
                            bloc.searchByPhone(value);
                          },
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 25),
                          //textAlign: TextAlign.right,
                          controller: phoneController,
                          decoration: InputDecoration(
                            //suffix: Icon(Icons.phone,color: Colors.black,),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TransactionHeaderColumn(
                          title: 'Estimated time',
                          price: 'Phone number',
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
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: StreamBuilder(
                              stream: bloc.getWaitingListStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != "Error") {
                                    var listWidget = <Widget>[];
                                    List<WaitingSlot> list =
                                        snapshot.data as List<WaitingSlot>;
                                    list.forEach((data) {
                                      listWidget.add(
                                        WaitingSlotColumn(
                                          number: data.time!,
                                          phonenum: data.phonenum!,
                                          width: width,
                                          icon: Icon(Icons.clear),
                                          onPressedIcon: () {
                                            print("cancel");
                                          },
                                        ),
                                      );
                                    });
                                    return Column(
                                      children: listWidget,
                                    );
                                  } else {
                                    return Center(
                                        child: Text(
                                      'Queue list is empty',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 25),
                                    ));
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 7,
                                      backgroundColor:
                                          AppColor.PRIMARY_TEXT_WHITE,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

//   void onCancelClicked(BuildContext context, WaitingSlot slot) {
//     FocusScope.of(context).unfocus();
//     String actor = '';
//     if (customerCanceled) {
//       actor = slot.cusId;
//     } else {
//       actor = slot.nfc;
//     }
//     if (reasonController.text != null) {
//       //finishBloc.finishTransactionBloc(context, "1", widget.transaction.id);
//       cancelBloc.cancelTransactionBloc(
//           context, slot.transactionId, reasonController.text, actor);
//       print("Huỷ nè");
//     } else {
//       OpenDialog.displayDialog("Error", context, "Vui lòng nhập lí do !!!");
//     }
//   }

//   openRatingBox(WaitingSlot slot) {
//     Color myColor = Color(0xff20b9f5);
//     customerCanceled = false;

//     return showDialog(
//       barrierDismissible: false,
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(32.0))),
//               contentPadding: EdgeInsets.only(top: 10.0),
//               content: Container(
//                 width: 500.0,
//                 height: 400,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 10, bottom: 10, left: 30.0),
//                           child: Text(
//                             "Người Hủy : ",
//                             style: TextStyle(fontSize: 20.0),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: customerCanceled,
//                               onChanged: (value) {
//                                 print(value);
//                                 setState(() {
//                                   customerCanceled = value;
//                                 });
//                               },
//                             ),
//                             Text(
//                               'Khách hàng',
//                               style: TextStyle(fontSize: 20),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.grey,
//                       height: 4.0,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           top: 10, bottom: 10, left: 30.0),
//                       child: Text(
//                         "Lí do Hủy ",
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey,
//                       height: 4.0,
//                     ),
//                     Container(
//                       height: 241,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 30.0, right: 30.0),
//                         child: TextFormField(
//                           controller: reasonController,
//                           decoration: InputDecoration(
//                             hintText: "Lí do hủy đơn",
//                             border: InputBorder.none,
//                           ),
//                           maxLines: 8,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         onCancelClicked(context, slot);
//                       },
//                       child: Container(
//                         padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(32.0),
//                               bottomRight: Radius.circular(32.0)),
//                         ),
//                         child: Text(
//                           "HỦY ĐƠN",
//                           style: TextStyle(color: Colors.white),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           });
//         });
//   }
}

class TransactionHeaderColumn extends StatelessWidget {
  final String title;
  final String price;
  final double width;
  TransactionHeaderColumn(
      {required this.price, required this.title, required this.width});
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
            width: width * 0.5,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              price,
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
