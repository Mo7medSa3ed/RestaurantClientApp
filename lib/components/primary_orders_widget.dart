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
              return RefreshIndicator(
                  onRefresh: () => fetchDate(true, widget.state, ctx),
                  child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: s.data['data'].length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6),
                      itemBuilder: (_, i) => PrimaryOrderCard(
                            s.data['data'][i],
                            onPressed: () async => await cancelOrder(
                                s.data['data'][i]['_id'], i, ctx),
                          )));
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
          app.ordersList[index] = parsed;
          setState(() {});
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
