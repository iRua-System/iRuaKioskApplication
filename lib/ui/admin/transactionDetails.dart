import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:kiosk/bloc/findTransactionDetail_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/models/transaction.dart';
import 'package:kiosk/ui/widgets/backButton.dart';
import 'package:kiosk/ui/widgets/helper.dart';
import 'package:kiosk/ui/widgets/service_column.dart';

class TransactionDetailsScreen extends StatefulWidget {
  String transId;
  String payment;
  String finish;
  String price;

  TransactionDetailsScreen(
      {Key? key,
      required this.transId,
      required this.payment,
      required this.finish,
      required this.price})
      : super(key: key);
  @override
  _TransactionDetailsScreen createState() => _TransactionDetailsScreen();
}

class _TransactionDetailsScreen extends State<TransactionDetailsScreen> {
  TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    bloc.findTransactionDetailBloc(context, widget.transId);
    super.initState();
  }

  FindTransactionDetailBloc bloc = FindTransactionDetailBloc();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController finishController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
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
          backgroundColor: AppColor.PRIMARY_BLUE,
          body: StreamBuilder(
              stream: bloc.findTransactionDetailStream,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != "Aloha" &&
                    snapshot.data != "Logging") {
                  Transaction transaction = snapshot.data as Transaction;
                  return Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xff43ddfb).withOpacity(0.8),
                              Color(0xff20b9f5),
                            ]),
                      ),
                    ),
                    Positioned(
                      left: 30,
                      top: 50,
                      child: MyBackButton(color: Colors.white),
                    ),
                    LeftWidget(
                      width: width,
                      height: height,
                      services: transaction.services!,
                      empname: transaction.emp!.fullname,
                      price: widget.price,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: height,
                          width: width / 2,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 50, left: 50),
                                width: width / 2,
                                child: Text(
                                  'Customer information',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Container(
                                  width: width / 2,
                                  child: Text(
                                    'Fullname',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  padding: EdgeInsets.only(left: 50),
                                  height: 60,
                                  width: width * 0.43,
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(fontSize: 25),
                                    controller: nameController
                                      ..text = transaction.cust!.fullname!,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff20b9f5),
                                            width: 2.0),
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: width * 0.43,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Row(
                                    children: [
                                      phoneField(width, "Phone number",
                                          transaction.cust!.phoneNum!),
                                      Spacer(),
                                      textField(
                                          width,
                                          "Plate",
                                          transaction.vehiclePlate!,
                                          plateController),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                width: width * 0.43,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Row(
                                    children: [
                                      textField(
                                          width,
                                          "Vehicle Type",
                                          transaction.vehicleName!,
                                          vehicleTypeController),
                                      Spacer(),
                                      textField(
                                          width,
                                          "Brand",
                                          transaction.vehicleBrand!,
                                          vehicleBrandController),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                width: width * 0.43,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Row(
                                    children: [
                                      textField(
                                          width,
                                          "Finished time",
                                          widget.finish.split("-")[2] +
                                              "-" +
                                              widget.finish.split("-")[1] +
                                              "-" +
                                              widget.finish.split("-")[0],
                                          finishController),
                                      Spacer(),
                                      textField(width, "Payment method",
                                          widget.payment, paymentController),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 7,
                      backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                    ),
                  );
                }
              })),
    );
  }

  Column textField(double width, String title, String data,
      TextEditingController controller) {
    if (data == "Other") {
      data = "Other";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: width / 6,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
            height: 60,
            width: width / 6,
            child: TextFormField(
              enabled: false,
              controller: controller..text = data,
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff20b9f5), width: 2.0),
                ),
              ),
            )),
      ],
    );
  }

  Column phoneField(double width, String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: width / 6,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: 60,
          width: width / 6,
          child: TextFormField(
            enabled: false,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 25),
            controller: phoneController..text = data,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff20b9f5), width: 2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding fullnameWidget(double width) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Container(
        width: width / 2,
        child: Text(
          'Fullname',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class LeftWidget extends StatefulWidget {
  const LeftWidget(
      {Key? key,
      required this.price,
      required this.width,
      required this.height,
      required this.services,
      required this.empname})
      : super(key: key);

  final double width;
  final double height;
  final String empname;
  final String price;
  final List<Service> services;

  @override
  _LeftWidgetState createState() => _LeftWidgetState();
}

class _LeftWidgetState extends State<LeftWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30),
      width: widget.width / 2,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 50, left: 50),
            width: widget.width / 2,
            child: Text(
              'Selected service',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: widget.width / 2,
            child: Text(
              'Staff :' + widget.empname,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          SingleChildScrollView(
            child: Column(
              children: [
                for (var data in widget.services)
                  ServiceColumn(
                    title: data.name!,
                    price: data.price.toString(),
                    status: "Finish",
                    isNew: false,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: widget.height - 500,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, color: Colors.grey[800]!),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Spacer(),
                  Text(MoneyFormat.formatMoney(widget.price),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
