import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/order.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/orderDetails.dart';
import 'package:resturantapp/screans/ordertimeline.dart';

class PrimaryOrderCard extends StatefulWidget {
  final order;
  final onPressed;
  final onPressedForOrderDelivery;

  PrimaryOrderCard(this.order,
      {this.onPressed, this.onPressedForOrderDelivery});
  @override
  _PrimaryOrderCardState createState() => _PrimaryOrderCardState();
}

class _PrimaryOrderCardState extends State<PrimaryOrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => OrderDetailsScrean(
                id: widget.order['_id'],
                lat: widget.order['distLocation'][1],
                lng: widget.order['distLocation'][0],
              ))),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
                title: Text(
                  'OrderId: ${widget.order['_id']}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Kprimary),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Date: ${DateFormat.yMMMMEEEEd().format(DateTime.parse(widget.order['updatedAt']))}\nTime: ${DateFormat("h:m a").format(DateTime.parse(widget.order['updatedAt']).toLocal())}', //'Date: ${widget.order['updatedAt'].toString().substring(0, 10)}\t\t\tTime: ${widget.order['updatedAt'].toString().substring(11, 16)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Kprimary.withOpacity(0.6)),
                  ),
                ),
                trailing: Text(
                  '${widget.order['state'].toString().toUpperCase()}',
                  style:
                      TextStyle(color: Kprimary, fontWeight: FontWeight.w600),
                ),
                leading: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '\$ ${widget.order['sum']}',
                      style: TextStyle(
                          color: Kprimary, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ))),
            widget.order['state'].toString().toLowerCase().trim() == 'confirmed'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Provider.of<AppData>(context, listen: false)
                                  .initTrackOrder(Order.fromJson(widget.order));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => OrderTimeLine()));
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(red),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(12))),
                            child: Text(
                              'Track Your Order',
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: widget.onPressedForOrderDelivery,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Kprimary.withOpacity(0.95)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(12))),
                            child: Text(
                              'Order Delivered',
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : widget.order['state'].toString().toLowerCase().trim() ==
                        "placed"
                    ? TextButton(
                        onPressed: widget.onPressed,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(red),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(12))),
                        child: Text(
                          'Cancel Order',
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.w500),
                        ),
                      )
                    : Container(),
          ],
        ),
      ),
    );
  }
}
