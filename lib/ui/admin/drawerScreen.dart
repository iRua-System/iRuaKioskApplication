import 'package:flutter/material.dart';
import 'package:kiosk/bloc/getStoreConfigure_bloc.dart';
import 'package:kiosk/constants/appColor.dart';
import 'package:kiosk/models/store.dart';
import 'package:kiosk/ui/admin/adminHome.dart';
import 'package:kiosk/ui/admin/feedbacks_manage.dart';
import 'package:kiosk/ui/admin/onlineHour.dart';
import 'package:kiosk/ui/admin/service_manage.dart';
import 'package:kiosk/ui/admin/storeConfigure.dart';
import 'package:kiosk/ui/admin/transaction_manage.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  List<Map> drawerItems = [
    {
      'icon': Icons.store,
      'title': 'Store',
      'page': HomePage(
        screen: StoreConfigure(),
      )
    },
    {
      'icon': Icons.timelapse,
      'title': 'Online Working Hour',
      'page': HomePage(screen: OnlineHour())
    },
    {
      'icon': Icons.assignment_turned_in_outlined,
      'title': 'Transaction History',
      'page': HomePage(screen: TransactionManage())
    },
    {
      'icon': Icons.design_services,
      'title': 'Service Management',
      'page': HomePage(screen: ServiceManage())
    },
    {
      'icon': Icons.feedback,
      'title': 'Feedback',
      'page': HomePage(screen: FeedbackManage())
    },
  ];
  GetConfigureBloc bloc = GetConfigureBloc();
  @override
  void initState() {
    bloc.getConfigureBloc(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1fa2ff),
      // Color(0xff1fa2ff),
      // Color(0xff12d8fa),
      // Color(0xffa6ffcb),
      padding: EdgeInsets.only(top: 50, bottom: 70, left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
              stream: bloc.getConfigure,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != "NOSTORE") {
                  var data = snapshot.data as Store;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage(data.ownerImage.toString()),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.ownerName!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          ),
                          Text(
                            'Owner',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ],
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
          Column(
            children: drawerItems
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          print("alo");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => e['page']));
                        },
                        child: Row(
                          children: [
                            Icon(
                              e['icon'],
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(width: 10),
                            Text(
                              e['title'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
