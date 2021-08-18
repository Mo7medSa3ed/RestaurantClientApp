import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_order_Card.dart';
import 'package:resturantapp/components/primary_orders_widget.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';

class AllOrdersScrean extends StatefulWidget {
  @override
  _AllOrdersScreanState createState() => _AllOrdersScreanState();
}

class _AllOrdersScreanState extends State<AllOrdersScrean> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'All Orders',
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Kprimary, fontSize: 28),
            ),
            bottom: TabBar(
              unselectedLabelColor: Kprimary.withOpacity(0.6),
              overlayColor: MaterialStateProperty.all(red),
              indicatorColor: Kprimary,
              unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Kprimary.withOpacity(0.6),
                  fontSize: 14),
              labelColor: Kprimary,
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w800, color: Kprimary, fontSize: 16),
              tabs: [
                Tab(
                  text: "Recent",
                ),
                Tab(
                  text: "Confirmed",
                ),
                Tab(
                  text: "Delivered",
                ),
                Tab(
                  text: "Canceled",
                ),
              ],
            ),
          ),
          body: TabBarView(physics: BouncingScrollPhysics(),
              //controller: controller,
              children: [
                OrdersWidget('Placed'),
                OrdersWidget('Confirmed'),
                OrdersWidget('Delivered'),
                OrdersWidget('Canceled'),
              ])),
    );
  }
}
