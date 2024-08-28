import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kiosk/bloc/checkPlate_bloc.dart';
import 'package:kiosk/bloc/getVehicleType_bloc.dart';
import 'package:kiosk/constants/api.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/autoComplete.dart';
import 'package:kiosk/models/customer.dart';
import 'package:kiosk/models/service.dart';
import 'package:kiosk/ui/booking/member/unbooked/getWalkinService.dart';
import 'package:kiosk/ui/widgets/backButton.dart';

class GetWalkinInfo extends StatefulWidget {
  final String phoneNum;
  final Customer cust;

  const GetWalkinInfo({Key? key, required this.phoneNum, required this.cust})
      : super(key: key);
  @override
  _GetWalkinInfo createState() => _GetWalkinInfo();
}

class _GetWalkinInfo extends State<GetWalkinInfo> {
  GetServicesOfVehicleTypeBloc getServicesBloc = GetServicesOfVehicleTypeBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CheckPlateBloc checkBloc = CheckPlateBloc();
  String vehicleType = '';
  String vehicleBrand = '';
  late List<Service> serviceList;
  @override
  void initState() {
    serviceList = [];
    getServicesBloc.getVehicleTypeBloc(context);

    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;
    getServicesBloc.getVehicleBrandBloc(context, vehicleType);
    if (nameController.text == "") {
      nameController..text = widget.cust.fullname ?? '';
    }
    if (plateController.text == "") {
      plateController..text = widget.cust.vehiclePlate ?? '';
    }
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (!focusScopeNode.hasPrimaryFocus) {
          focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColor.PRIMARY_BLUE,
          body: Stack(children: [
            // Container(
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: AssetImage("assets/images/wallpaper4.jpg"),
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
              left: 30,
              top: 50,
              child: MyBackButton(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: height,
                    width: width * 0.6,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Container(
                                          height: height / 10,
                                          width: width * 0.5,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.grey[400]!),
                                            ),
                                          ),
                                          child: Row(children: [
                                            StepBox(
                                              number: 1,
                                              title: 'Collect information',
                                              activeBox: Color(0xff20b9f5),
                                              activeText: Colors.white,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: width / 20),
                                            StepBox(
                                              number: 2,
                                              title: 'Select service',
                                              activeBox: Colors.grey[200]!,
                                              activeText: Colors.grey,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(width: width / 20),
                                            StepBox(
                                              number: 3,
                                              title: 'Finalise',
                                              activeBox: Colors.grey[200]!,
                                              activeText: Colors.grey,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ]),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: width / 15,
                                  child: Text(
                                    'Step 1/3',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: width / 3,
                                  child: Text(
                                    'Information ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    width: width / 3,
                                    child: Text(
                                      'Fullname',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 70,
                                    width: width * 0.5,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      maxLength: 100,
                                      validator: (value) {
                                        RegExp regExp = new RegExp(
                                            r'^[^(0-9)@$!#%^&*()?><`{}~_=]{5,}$');
                                        if (value!.isEmpty) {
                                          return "Name can't be empty";
                                        }
                                        if (!regExp.hasMatch(value)) {
                                          return "Name is invalid";
                                        }
                                        return null;
                                      },
                                      //textAlign: TextAlign.right,
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        // labelText: 'Số điện thoại',
                                        // labelStyle: TextStyle(fontSize: 20),
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
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: width / 3.325,
                                            child: Text(
                                              'Phone number',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          width: width / 5,
                                          child: TextFormField(
                                            enabled: false,
                                            validator: (value) {
                                              RegExp regExp = new RegExp(
                                                  RegexConstants.NZPHONEREGEX);
                                              if (value!.isEmpty) {
                                                return "Phone number can't be empty";
                                              }
                                              if (!regExp.hasMatch(value)) {
                                                return "Phone number isn't valid";
                                              }
                                              return null;
                                            },
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontSize: 20),
                                            controller: phoneController
                                              ..text = widget.phoneNum,
                                            decoration: InputDecoration(
                                              // labelText: 'Số điện thoại',
                                              // labelStyle: TextStyle(fontSize: 20),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff20b9f5),
                                                    width: 2.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: width / 5,
                                            child: Text(
                                              'Plate',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: 70,
                                            width: width / 5,
                                            child: TextFormField(
                                              validator: (value) {
                                                RegExp regExp = new RegExp(
                                                    RegexConstants
                                                        .NZPLATEREGEX);
                                                if (value!.trim().isEmpty) {
                                                  return "Plate can't be empty";
                                                }
                                                if (!regExp.hasMatch(value)) {
                                                  return "Plate is invalid";
                                                }
                                                return null;
                                              },
                                              maxLength: 10,
                                              //textAlign: TextAlign.right,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              controller: plateController..text,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                              decoration: InputDecoration(
                                                counterText: "",
                                                // labelText: 'Số điện thoại',
                                                // labelStyle: TextStyle(fontSize: 20),
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
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: width / 5,
                                            child: Text(
                                              'Vehicle Type',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        StreamBuilder(
                                            stream: getServicesBloc.vehicleType,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                print(snapshot.data);
                                                List<String> temp = snapshot
                                                    .data as List<String>;
                                                return Container(
                                                    height: 70,
                                                    width: width / 5,
                                                    child: TypeAheadFormField(
                                                      validator: (value) {
                                                        if (value!
                                                            .trim()
                                                            .isEmpty) {
                                                          return "Vehicle Type can't be empty";
                                                        }
                                                      },
                                                      suggestionsBoxDecoration:
                                                          SuggestionsBoxDecoration(
                                                              constraints:
                                                                  BoxConstraints(
                                                        maxWidth: width / 5,
                                                      )),
                                                      textFieldConfiguration:
                                                          TextFieldConfiguration(
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                        autocorrect: true,
                                                        autofocus: false,
                                                        controller:
                                                            vehicleTypeController,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 10),
                                                          ),
                                                        ),
                                                      ),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              itemData) {
                                                        var temp =
                                                            itemData as String;
                                                        return ListTile(
                                                          title: Text(
                                                            temp.split(".")[1],
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) {
                                                        var temp = suggestion
                                                            as String;
                                                        vehicleTypeController
                                                                .text =
                                                            temp.split(".")[1];
                                                        vehicleType =
                                                            temp.split(".")[1];
                                                        getServicesBloc
                                                            .getVehicleBrandBloc(
                                                                context,
                                                                vehicleType);
                                                        vehicleBrandController
                                                            .clear();
                                                        vehicleBrand = '';
                                                      },
                                                      suggestionsCallback:
                                                          (String
                                                              pattern) async {
                                                        return AutoCompleteText(
                                                                temp)
                                                            .getSuggestions(
                                                                pattern);
                                                      },
                                                    ));
                                              } else {
                                                return Container(
                                                  height: 70,
                                                  width: width / 5,
                                                  decoration: BoxDecoration(
                                                    // labelText: 'Số điện thoại',
                                                    // labelStyle: TextStyle(fontSize: 20),
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1),
                                                  ),
                                                );
                                              }
                                            }),
                                      ],
                                    ),
                                    SizedBox(width: 120),
                                    StreamBuilder(
                                      stream: getServicesBloc.vehicleBrand,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<String> temp =
                                              snapshot.data as List<String>;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Container(
                                                  width: width / 5,
                                                  child: Text(
                                                    'Vehicle Brand',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: width / 5,
                                                child: TypeAheadField(
                                                  suggestionsBoxDecoration:
                                                      SuggestionsBoxDecoration(
                                                          constraints:
                                                              BoxConstraints(
                                                    maxWidth: width / 5,
                                                  )),
                                                  textFieldConfiguration:
                                                      TextFieldConfiguration(
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    autocorrect: true,
                                                    autofocus: false,
                                                    controller:
                                                        vehicleBrandController,
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 10),
                                                      ),
                                                    ),
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          itemData) {
                                                    var temp =
                                                        itemData as String;
                                                    return ListTile(
                                                      title: Text(
                                                        temp,
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    );
                                                  },
                                                  onSuggestionSelected:
                                                      (suggestion) {
                                                    vehicleBrandController
                                                            .text =
                                                        suggestion as String;
                                                    vehicleBrand = suggestion;
                                                  },
                                                  suggestionsCallback:
                                                      (String pattern) async {
                                                    return AutoCompleteText(
                                                            temp)
                                                        .getSuggestions(
                                                            pattern);
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                StreamBuilder(
                                    stream: getServicesBloc
                                        .getServicesOfVehicleType,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        serviceList =
                                            snapshot.data as List<Service>;
                                      }
                                      return SizedBox();
                                    }),
                                SizedBox(
                                  height: height / 17,
                                ),
                                Container(
                                  height: 100,
                                  width: width * 0.5,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1, color: Colors.grey[400]!),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        onSignInClicked(context);
                                      },
                                      child: Container(
                                        height: 60,
                                        child: Container(
                                          width: width / 5,
                                          child: Text(
                                            'NEXT',
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
      String fullname = nameController.text;
      String plate = plateController.text;
      String vehicleBrand = vehicleBrandController.text;
      Customer cust = Customer(
          fullname: fullname,
          phoneNum: phoneNum,
          plate: plate,
          vehicleBrand: vehicleBrand,
          deviceToken: widget.cust.deviceToken);
      checkBloc.checkPlateBloc(context, plate, cust, serviceList, vehicleType);
      print(cust.deviceToken);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GetWalkinService(
                cust: cust,
                serviceList: serviceList,
                vehicleType: vehicleType,
              )));
    }
  }
}

class StepBox extends StatelessWidget {
  final int number;
  final String title;
  final Color activeBox;
  final Color activeText;
  final TextStyle style;

  const StepBox(
      {Key? key,
      required this.number,
      required this.title,
      required this.activeBox,
      required this.activeText,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(color: activeBox),
          width: 40,
          height: 40,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(color: activeText, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: style,
        ),
      ],
    );
  }
}
