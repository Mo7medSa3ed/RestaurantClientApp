import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/admin/orderdetails.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class OrdersPage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<OrdersPage> {
  AppData appData;

  Future<List<Address>> getcurrantLocation(o) async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(o[1], o[0]);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses;
  }

  g() async {
    await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();
    await Geolocator.checkPermission();
  }

  getallusers() async {
    final res = await API.getAllUser();
    if (res.length > 0) {
      appData.initUserList(res);
    }
  }

  @override
  void initState() {
    super.initState();
    g();
    appData = Provider.of<AppData>(context, listen: false);
    getallusers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context, listen: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: FutureBuilder(
            future: API.getAllOrders(),
            builder: (c, v) {
              if (v.hasData) {
                appData.initOrderList(v.data);
                return Scaffold(
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      body(
                          0,
                          appData.ordersList
                              .where((e) =>
                                  e['state'].toString().toLowerCase().trim() ==
                                  'placed')
                              .toList()),
                      body(
                          1,
                          appData.ordersList
                              .where((e) =>
                                  e['state'].toString().toLowerCase().trim() ==
                                      'confirmed' ||
                                  e['state'].toString().toLowerCase().trim() ==
                                      'onway')
                              .toList()),
                      body(
                          2,
                          appData.ordersList
                              .where((e) =>
                                  e['state'].toString().toLowerCase().trim() ==
                                      'ready' ||
                                  e['state'].toString().toLowerCase().trim() ==
                                      'cancel')
                              .toList()),
                    ],
                  ),
                  appBar: AppBar(
                    elevation: 2,
                    backgroundColor: white.withOpacity(0.97),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                          color: Kprimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w700),
                    ),
                    bottom: TabBar(
                        indicatorColor: red,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3,
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        unselectedLabelStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        unselectedLabelColor: Kprimary.withOpacity(0.3),
                        labelColor: red,
                        tabs: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text('New')),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text('Active')),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text('History')),
                        ]),
                  ),
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: Center(
                        child: SpinKitCircle(
                      color: Kprimary,
                    )),
                  ),
                );
              }
            }));
  }

  Widget body(indx, list) {
    SizeConfig().init(context);
    // final hei = MediaQuery.of(context).size.height;
    // final wid = MediaQuery.of(context).size.width;
    int index = indx;

    return ListView.builder(
              physics: BouncingScrollPhysics(),

      itemCount: list.length,
      itemBuilder: (c, i) => index == 0
          ? GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderDetailsScrean(list[i]['_id']))),
              child: neworderCard('Cancel', list[i]))
          : index == 1
              ? GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => OrderDetailsScrean(list[i]['_id']))),
                  child: activeorderCard(list[i]))
              : GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => OrderDetailsScrean(list[i]['_id']))),
                  child: neworderCard(
                      list[i]['state'].toString().toLowerCase().trim() ==
                              'cancel'
                          ? 'Canceled'
                          : 'Delivered',
                      list[i])),
    );
  }

  Widget neworderCard(text, o) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.fastfood,
                color: red,
              ),
              title: Text(
                "OID ${o['_id']}",
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Kprimary),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Paymant",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Kprimary.withOpacity(0.4)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "\$ ${o['sum']}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Kprimary),
                    ),
                  ],
                ),
              ),
              trailing: ElevatedButton(
                onPressed: text == 'Delivered' || text == 'Canceled'
                    ? () {}
                    : () async => cancelOrder(o['_id']),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(red),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
                child: Text(
                  '$text',
                  style: TextStyle(color: greyw),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            FutureBuilder(
                future: getcurrantLocation(o['distLocation']),
                builder: (c, s) {
                  if (s.hasData) {
                    return buildRowAddres(
                      s.data,
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 40,
                      color: greyw,
                      child: Text(
                        "loading.....",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Kprimary),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget activeorderCard(o) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.fastfood,
                color: red,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "OID ${o['_id']}",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Kprimary),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Delivery Name : Mohamed Saeed Eliwah",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Kprimary.withOpacity(0.6)),
                  ),
                ],
              ),
              trailing: Column(
                children: [
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Paymant",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Kprimary.withOpacity(0.4)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "\$ ${o['sum']}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Kprimary),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            FutureBuilder(
                future: getcurrantLocation(o['distLocation']),
                builder: (c, s) {
                  if (s.hasData) {
                    print(s.data);
                    return buildRowAddres(
                      s.data,
                    );
                  } else {
                    return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: double.infinity,
                        alignment: Alignment.center,
                        height: 40,
                        color: greyw,
                        child: Text(
                          "loading.....",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Kprimary),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          textAlign: TextAlign.center,
                        ));
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget buildRowAddres(List<Address> a) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 40,
      color: greyw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "Restaurant Address",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Kprimary),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: red,
                ),
                CircleAvatar(
                  backgroundColor: red,
                  radius: 2.5,
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: red,
                  radius: 2.5,
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: red,
                  radius: 2.5,
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: red,
                  radius: 2.5,
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: red,
                  radius: 2.5,
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: red,
                  radius: 2.5,
                ),
                Icon(
                  Icons.navigation,
                  color: red,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              a.first.addressLine,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Kprimary),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          )
        ],
      ),
    );
  }

  cancelOrder(id) async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: 'Cancel Order',
      text: "Are you sure to cancel order ?",
      barrierDismissible: false,
      confirmBtnColor: red,
      showCancelBtn: true,
      onConfirmBtnTap: () async {
        Navigator.of(context).pop();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          text: "loading please wait....",
          barrierDismissible: false,
        );
        final reqData = {"state": "cancel"};
        final res = await API.patchOrder(reqData, id);
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          final body = utf8.decode(res.bodyBytes);
          final parsed = json.decode(body);
          appData.updateOrder(parsed);

          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              animType: CoolAlertAnimType.slideInUp,
              title: 'Cancel Order',
              text: "Order Canceled Successfully",
              barrierDismissible: false,
              confirmBtnColor: Kprimary,
              onConfirmBtnTap: () => Navigator.of(context).pop());
        } else {
          Navigator.of(context).pop();
          CoolAlert.show(
              context: context,
              type: CoolAlertType.loading,
              title: 'Error',
              text: "some thing went error !!",
              barrierDismissible: false,
              showCancelBtn: true);
        }
      },
    );
  }

  /* acceptOrder(id) async {
    AppData app = Provider.of<AppData>(context, listen: false);
    final l = app.orderList
        .where((e) =>
            e['deliveryId'] == app.loginUser.id &&
            e['state'].toString().toLowerCase().trim() == 'confirmed')
        .toList();
    if (l.length == 0) {
      CoolAlert.show(
        context: context,
        animType: CoolAlertAnimType.slideInUp,
        type: CoolAlertType.info,
        confirmBtnColor: Kprimary,
        text: "Finish Active Order ,First !!",
        barrierDismissible: false,
        onConfirmBtnTap: ()=> Navigator.of(context).pop()
        
      );
      return;
    }
    CoolAlert.show(
      context: context,
      animType: CoolAlertAnimType.slideInUp,
      type: CoolAlertType.loading,
      text: "loading please wait....",
      barrierDismissible: false,
    );
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final reqData = {
      "state": "confirmed",
      "deliveryId": app.loginUser.id,
      "deliveryLocation": [position.longitude, position.latitude]
    };
    final res = await API.patchOrder(reqData, id);
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      app.updateOrder(parsed);
      Navigator.of(context).pop();
      CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          animType: CoolAlertAnimType.slideInUp,
          title: 'Accept Order',
          text: "Order Accepted Successfully",
          barrierDismissible: false,
          confirmBtnColor: Kprimary,
          onConfirmBtnTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => Home(1))));
      setState(() {});
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          animType: CoolAlertAnimType.slideInUp,
          title: 'Error',
          text: "some thing went error !!",
          barrierDismissible: false,
          showCancelBtn: true);
    }
  } */

}
