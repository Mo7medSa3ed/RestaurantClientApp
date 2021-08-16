import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/order.dart';
import 'package:resturantapp/screans/orderDetails.dart';
import 'package:resturantapp/screans/ordertimeline.dart';

class PrimaryOrderCard extends StatefulWidget {
  final order;
  final onPressed;

  PrimaryOrderCard(this.order, {this.onPressed});
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
        elevation: 2,
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
            widget.order['state'].toString().toLowerCase().trim() ==
                        'confirmed' ||
                    widget.order['state'].toString().toLowerCase().trim() ==
                        'onway'
                ? TextButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => OrderTimeLine(
                                  id: widget.order['_id'],
                                  state: widget.order['state'],
                                  delivarylocation:
                                      widget.order['deliveryLocation'],
                                  dislocation: widget.order['distLocation'],
                                ))),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(red),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12))),
                    child: Text(
                      'Track Your Order',
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.w500),
                    ),
                  )
                : widget.order['state'].toString().toLowerCase().trim() !=
                        "cancel"
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
