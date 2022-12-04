import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/notification.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/alldishes.dart';
import 'package:resturantapp/screans/allorders.dart';
import 'package:resturantapp/screans/cart.dart';
import 'package:resturantapp/screans/details.dart';
import 'package:resturantapp/screans/favourite.dart';
import 'package:resturantapp/screans/homepage.dart';
import 'package:resturantapp/screans/ordertimeline.dart';
import 'package:resturantapp/screans/profile.dart';
import 'package:resturantapp/screans/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppData appData;
  static const channel = MethodChannel("notification");

  List<Widget> pages = [
    HomePage(),
    FavouriteScrean(),
    SearchScrean(),
    CartScrean(),
    AllOrdersScrean(),
    Profile(),
  ];
  int index = 0;

  void getNotificationDataIfExist() async {
    final notificationData = await channel.invokeMethod("getNotification");
    final type = notificationData.split('/')[0];
    final id = notificationData.split('/')[1];
    if (type == null || id == null) return;
    switch (type) {
      case 'dish':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => DetailsScrean(id)));
        break;
      case 'category':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AllDishScrean(
                  type,
                  catId: id,
                )));
        break;
      case 'orderConfirmed':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => OrderTimeLine()));
        break;
    }
  }

  @override
  void initState() {
    getNotificationDataIfExist();
    notificationPlugin
        .setListnerForLowerVersions(onNotificationInlowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    super.initState();
  }

  onNotificationInlowerVersions(ReceivedNotification receivedNotification) {}

  Future onNotificationClick(String payload) async {
    final type = payload.split('/')[0];
    final id = payload.split('/')[1];
    switch (type) {
      case 'dish':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => DetailsScrean(id)));
        break;
      case 'category':
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AllDishScrean(
                  type,
                  catId: id,
                )));
        break;
      case 'orderConfirmed':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => OrderTimeLine()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.97),
          unselectedItemColor: Kprimary,
          selectedItemColor: red,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "")
          ]),
      appBar: AppBar(
        /*  automaticallyImplyLeading: false, */
        /* leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Kprimary.withOpacity(0.5),
          ),
          onPressed: () {},
        ) */
        // leadingWidth: MediaQuery.of(context).size.width * 0.9,
        // leading: Container(
        //     child: Image.asset(
        //   "assets/images/del.png",
        // )),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     color: Kprimary.withOpacity(0.5),
          //   ),
          //   onPressed: () => Navigator.of(context)
          //       .push(MaterialPageRoute(builder: (_) => SearchScrean())),
          // ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Kprimary.withOpacity(0.5),
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: pages[index],
    );
  }
}
