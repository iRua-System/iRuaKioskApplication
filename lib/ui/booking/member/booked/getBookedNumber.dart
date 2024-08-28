import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/checkBookedCustomer_bloc.dart';
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/store.dart';
import 'package:kiosk/ui/widgets/backButton.dart';

class GetBookedNumberScreen extends StatefulWidget {
  final Store store;

  const GetBookedNumberScreen({Key? key, required this.store})
      : super(key: key);
  @override
  _GetBookedNumberScreen createState() => _GetBookedNumberScreen();
}

class _GetBookedNumberScreen extends State<GetBookedNumberScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  CheckBookedCustomerBloc bloc = CheckBookedCustomerBloc();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
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
          body: Stack(children: [
            // Container(
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: AssetImage("assets/images/wallpaper6.jpg"),
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
              left: 50,
              top: 30,
              child: Container(
                height: height / 6,
                width: width / 7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icons/iconwhite.png"))),
              ),
            ),
            Positioned(
              left: 50,
              top: width / 4,
              child: Container(
                height: height / 6,
                width: width / 2,
                child: Text(
                  widget.store.storeName!,
                  style: TextStyle(
                      fontSize: 37,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              left: 50,
              top: width / 3,
              child: Container(
                height: height / 6,
                width: width / 2,
                child: Column(
                  children: [
                    Text(
                      widget.store.address!,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.store.phone!,
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 30,
              top: 50,
              child: MyBackButton(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: height,
                  width: width / 2.5,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 65.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 200),
                                      Container(
                                        width: width / 3,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Customer's phone number",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 40,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        width: width / 3,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "To facilitate better management, please provide the customer's phone number.",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                          height: 70,
                                          width: width / 3,
                                          child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              maxLength: 10,
                                              validator: (value) {
                                                RegExp regExp = new RegExp(
                                                    RegexConstants
                                                        .NZPHONEREGEX);
                                                if (value!.isEmpty) {
                                                  return "Phone number can't be empty";
                                                }
                                                if (!regExp.hasMatch(value)) {
                                                  return "Phone number isn't valid";
                                                }
                                                return null;
                                              },
                                              textAlign: TextAlign.right,
                                              controller: phoneController,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                labelText: 'Phone number',
                                                labelStyle:
                                                    TextStyle(fontSize: 20),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xff20b9f5),
                                                      width: 2.0),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              StreamBuilder(
                                  stream: bloc.isLogging,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data == 'Logging') {
                                        return Container(
                                          height: 60,
                                          child: Container(
                                            width: width / 4,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                          Color>(
                                                      AppColor.PRIMARY_BLUE),
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColor.PRIMARY_TEXT_WHITE,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            onSignInClicked(context);
                                          },
                                          child: Container(
                                            height: 60,
                                            child: Container(
                                              width: width / 3,
                                              child: Text(
                                                'CONFIRM',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color(0xff43ddfb),
                                                      Color(0xff20b9f5),
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          onSignInClicked(context);
                                        },
                                        child: Container(
                                          height: 60,
                                          child: Container(
                                            width: width / 3,
                                            child: Text(
                                              'CONFIRM',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20),
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xff43ddfb),
                                                    Color(0xff20b9f5),
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  })
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ])),
    );
  }

  void onSignInClicked(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (this._formKey.currentState!.validate()) {
      String phoneNum = phoneController.text;
      bloc.checkBookedMember(context, phoneNum, false);
    }

    //  Navigator.of(context).push(
    //        MaterialPageRoute(builder: (context) => UnbookedMemberCheckIn(cust:null)));
  }
}
