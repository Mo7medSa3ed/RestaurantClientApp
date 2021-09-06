import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_order_Card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';

class OrdersWidget extends StatefulWidget {
  final state;
  OrdersWidget(this.state);
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  bool status = false;
  AppData app;

  Future<void> fetchDate(init, state, context) async {
    await API.getAllOrders(state: state).then((value) {
      status = value['status'];
      if (value['status']) {
        app.initOrderList(value['data']);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    app = Provider.of<AppData>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API.getAllOrders(state: widget.state),
        builder: (ctx, s) {
          if (s.hasData) {
            if (s.data['status'] && s.data['data'].length > 0) {
              app.initOrderList(s.data['data']);

              return RefreshIndicator(
                  onRefresh: () => fetchDate(true, widget.state, ctx),
                  child: Consumer<AppData>(
                    builder: (ctx2, orders, c) => ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: orders.ordersList.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 6),
                        itemBuilder: (_, i) => PrimaryOrderCard(
                              orders.ordersList[i],
                              onPressedForOrderDelivery: () async =>
                                  await deliveryOrder(
                                      orders.ordersList[i]['_id'], i, ctx2),
                              onPressed: () async => await cancelOrder(
                                  orders.ordersList[i]['_id'], i, ctx2),
                            )),
                  ));
            } else {
              return Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/List.png",
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                          ),
                          Text(
                            "Your ${widget.state} Orders is Empty",
                            style: TextStyle(color: grey, fontSize: 18),
                          )
                        ],
                      )));
            }
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  deliveryOrder(id, index, context) async {
    final app = Provider.of<AppData>(context, listen: false);

    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: 'Order Delivery',
      text: "Are you sure order is delivered ?",
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
        final reqData = {"state": "delivered"};
        final res = (await API.patchOrder(reqData, id));
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          final body = utf8.decode(res.bodyBytes);
          final parsed = json.decode(body);
          app.clearOrder(parsed['_id']);
          if (app.ordersList.length == 0) setState(() {});
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              animType: CoolAlertAnimType.scale,
              title: 'Order Delivery',
              text: "Order Delivered Successfully",
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

  cancelOrder(id, index, context) async {
    final app = Provider.of<AppData>(context, listen: false);
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
        final reqData = {"state": "canceled"};
        final res = (await API.patchOrder(reqData, id));
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          final body = utf8.decode(res.bodyBytes);
          final parsed = json.decode(body);
          app.changeOrderState(parsed['_id'], "canceled");
          if (app.ordersList.length == 0) setState(() {});
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              animType: CoolAlertAnimType.scale,
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
