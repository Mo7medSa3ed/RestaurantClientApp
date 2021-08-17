import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_order_Card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';

class AllOrdersScrean extends StatefulWidget {
  @override
  _AllOrdersScreanState createState() => _AllOrdersScreanState();
}

class _AllOrdersScreanState extends State<AllOrdersScrean> {
  AppData app;
  int page = 0;
  bool isLast = false;
  bool status = false;
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    app = Provider.of<AppData>(context, listen: false);
    fetchDate(true);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchDate(false);
      }
    });
  }

  fetchDate(init) async {
    if (init) {
      page = 1;
      isLast = false;
      app.clearAllOrderList();
    } else {
      page++;
    }
    if (isLast == false) {
      await API.getAllOrders(page: page).then((value) {
        status = value['status'];
        if (value['status']) {
          if (value['data'].length < 6) {
            isLast = true;
            setState(() {});
          }
          app.initOrderList(value['data']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'All Orders',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Kprimary, fontSize: 28),
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () => fetchDate(true),
              child: Consumer<AppData>(
                builder: (ctx, app, c) => (app.ordersList.length > 0 && status)
                    ? ListView.builder(
                        controller: scrollController,
                        physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: app.ordersList.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6),
                        itemBuilder: (_, i) => PrimaryOrderCard(
                              app.ordersList[i],
                              onPressed: () async => await cancelOrder(
                                  app.ordersList[i]['_id'], i),
                            ))
                    : (status && app.ordersList.length == 0)
                        ? Center(
                            child: emptyTextWidget,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  cancelOrder(id, index) async {
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
        final res = (await API.patchOrder(reqData, id))['data'];
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          final body = utf8.decode(res.bodyBytes);
          final parsed = json.decode(body);
          app.ordersList[index] = parsed;
          setState(() {});
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
}
