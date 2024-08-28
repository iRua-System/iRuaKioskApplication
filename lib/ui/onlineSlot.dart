import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/bloc/getDefaultOnlineHour_bloc.dart';
import 'package:kiosk/bloc/getOnlineSlotList_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/onlineDate.dart';
import 'package:kiosk/models/onlineSlot.dart';
import 'package:kiosk/models/onlineSlotPerHour.dart';
import 'package:kiosk/ui/widgets/backButton.dart';

class OnlineSlotPage extends StatefulWidget {
  @override
  _OnlineSlotState createState() => _OnlineSlotState();
}

class _OnlineSlotState extends State<OnlineSlotPage> {
  GetOnlineSlotListBloc getBloc = GetOnlineSlotListBloc();
  GetDefaultOnlineHourBloc slotBloc = GetDefaultOnlineHourBloc();
  @override
  void initState() {
    getBloc.getOnlineSlotListBloc(context);
    // TODO: implement initState
    super.initState();
    slotBloc.getDefaultConfigureBloc(context);
  }

  String limitedSlot = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Container(
          //     decoration: BoxDecoration(
          //         image: DecorationImage(
          //             image: AssetImage("assets/images/wallpaper2.jpeg"),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: height * 0.1),
                  Container(
                    width: width,
                    height: height * 0.15,
                    child: Text('NUMBER OF ONLINE ORDERS TODAY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  SingleChildScrollView(
                    child: StreamBuilder(
                        stream: slotBloc.getDefaultOnlineHour,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            OnlineDate data = snapshot.data as OnlineDate;
                            limitedSlot = data.limitedSlot!;
                            return Container(
                              width: width * 0.9,
                              height: height * 0.7,
                              decoration: BoxDecoration(
                                color: Color(0xff0099BF).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: StreamBuilder(
                                  stream: getBloc.getOnlineSlotList,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return buildTable(
                                          width,
                                          snapshot.data
                                              as List<OnlineSlotPerHour>,
                                          limitedSlot);
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 7,
                                          backgroundColor:
                                              AppColor.PRIMARY_TEXT_WHITE,
                                        ),
                                      );
                                    }
                                  }),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 7,
                                backgroundColor: AppColor.PRIMARY_TEXT_WHITE,
                              ),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHeader(String text, width) {
    return Container(
      height: 70,
      width: width / 2,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: text == null
          ? null
          : BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text != null ? text : "",
        style: TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildHour(String text, width) {
    return Container(
      height: 100,
      width: width / 2,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildContent(String phone, vehicleName, width) {
    return Container(
      height: 100,
      width: width / 2,
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xffF9F871), borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            phone != null ? phone : "",
            style: TextStyle(
                color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            vehicleName != null ? vehicleName : "",
            style: TextStyle(
                color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildTable(width, List<OnlineSlotPerHour> list, length) {
    return Container(
      width: width * 0.8,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Table(
                children: [
                  buildTableHeader(length, width),
                  for (var data in list) buildTableContent(length, data, width)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TableRow buildTableContent(length, OnlineSlotPerHour data, width) {
    List<OnlineSlot> list = [];
    for (var slot in data.transList!) {
      list.add(slot);
    }
    int test = num.tryParse(length)!.toInt() - data.transList!.length;
    for (int f = 0; f < test; f++) {
      OnlineSlot slot = OnlineSlot();
      list.add(slot);
    }

    return TableRow(children: [
      buildHour(data.time!, width),
      for (var data in list) buildContent(data.phone!, data.vehicleName, width)
    ]);
  }

  TableRow buildTableHeader(length, width) {
    List<String> list = [];
    int parsedLength = int.tryParse(length) ?? 0;
    for (int i = 0; i < parsedLength; i++) {
      int temp = i + 1;
      list.add(temp.toString());
    }
    return TableRow(children: [
      buildHeader('', width),
      for (var data in list) buildHeader(data, width)
    ]);

    // buildContent("Alo", width);
    // buildContent("Alo", width);
    // buildContent("Alo", width);
    // buildContent("Alo", width);
    // buildContent("Alo", width);
    // buildContent("Alo", width);
  }
}
