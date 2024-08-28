


import 'package:flutter/material.dart';
import 'package:kiosk/ui/admin/drawerScreen.dart';


class HomePage extends StatefulWidget {
  final Widget screen;

  const HomePage({ Key? key, required this.screen}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          DrawerScreen(),
          widget.screen
        ]
      ),
    );
    // return Scaffold(
    //   body: Row(
    //     children: [
    //       NavigationRail(
    //         minWidth: 150,
    //         selectedIndex: selectedIndex,
    //         onDestinationSelected: (int index) {
    //           setState(
    //             () {
    //               selectedIndex = index;
    //             },
    //           );
    //         },
    //         selectedLabelTextStyle: TextStyle(color: Colors.red),
    //         labelType: NavigationRailLabelType.all,
    //         backgroundColor: Color(0xff43ddfb).withOpacity(0.8),
    //         groupAlignment: 0,
    //         destinations: [
    //           NavigationRailDestination(
    //             icon: Icon(Icons.store, size: 70,),
    //             selectedIcon: Icon(Icons.store, size: 70,),
    //             label: Text('Thông tin'),
    //           ),
    //           NavigationRailDestination(
    //               icon: Padding(
    //                 padding: const EdgeInsets.only(top:30.0),
    //                 child: new Image.asset(
    //                   'assets/icons/24-hours.png',
    //                   color: Colors.black,
    //                   width: 70,
    //                   height: 70,

    //                 ),
    //               ),
    //               selectedIcon: Padding(
    //                 padding: const EdgeInsets.only(top:30.0),
    //                 child: new Image.asset(
    //                   'assets/icons/24-hours.png',
    //                   width: 30,
    //                   height: 30,
    //                 ),
    //               ),
    //               label: Text('Giờ Online')),
    //           NavigationRailDestination(
    //               icon: Padding(
    //                 padding: const EdgeInsets.only(top:50.0),
    //                 child: Icon(Icons.person),
    //               ),
    //               selectedIcon: Padding(
    //                 padding: const EdgeInsets.only(top:50.0),
    //                 child: Icon(Icons.person),
    //               ),
    //               label: Text('Tài Khoản')),
    //         ],
    //       ),
    //       Expanded(child: StoreConfigure()),
    //       Container(),
    //       Container(),
    //     ],
    //   ),
    // );

  }
  
}
