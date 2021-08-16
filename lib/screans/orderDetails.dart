import 'dart:ui';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primart_elevatedButtom.dart';
import 'package:resturantapp/components/primary_cart_card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/order.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:resturantapp/screans/home.dart';

class OrderDetailsScrean extends StatefulWidget {
  final id;
  final lat;
  final lng;
  OrderDetailsScrean({this.id, this.lat, this.lng});
  @override
  _OrderDetailsScreanState createState() => _OrderDetailsScreanState();
}

class _OrderDetailsScreanState extends State<OrderDetailsScrean> {
  AppData app;
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String address;
  String promo;
  bool isExist = false;
  Position position;
  List<Address> addresses;
  Order order;

  getcurrantLocation() async {
    await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();
    await Geolocator.checkPermission();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {});
  }

  getAddress(position) async {
    final coordinates = new Coordinates(position.latitude, position.longitude);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {});
  }

  @override
  void initState() {
    app = Provider.of<AppData>(context, listen: false);
    position = Position(latitude: widget.lat, longitude: widget.lng);
    getAddress(position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: FutureBuilder<dynamic>(
              future: API.getOneOrder(widget.id),
              builder: (ctx, v) {
                if (v.hasData) {
                  order = Order.fromJson(v.data);
                  app.initOrder(order);

                  return Consumer<AppData>(
                    builder: (ctx, app, c) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            physics: BouncingScrollPhysics(),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Details',
                                    style: TextStyle(
                                        color: Kprimary,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1),
                                    textAlign: TextAlign.start,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: red,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SHIPPING ADDRESS',
                                    style: TextStyle(
                                        color: Kprimary.withOpacity(0.35),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1),
                                    textAlign: TextAlign.start,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Kprimary.withOpacity(0.35),
                                      size: 30,
                                    ),
                                    onPressed: () => getcurrantLocation(),
                                  )
                                ],
                              ),
                              Text(
                                app.order.user.name,
                                style: TextStyle(
                                    color: Kprimary.withOpacity(0.85),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                addresses != null
                                    ? addresses.first.addressLine
                                    : app.order.address ?? '',
                                style: TextStyle(
                                    color: Kprimary.withOpacity(0.35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1),
                                softWrap: true,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'ITEMS',
                                style: TextStyle(
                                    color: Kprimary.withOpacity(0.35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: app.order.items
                                    .map((e) => PrimaryCartCard(
                                          e.dish,
                                          details: true,
                                          amount: e.amount,
                                          test: app.order.state.toLowerCase() ==
                                                  'deliverd'
                                              ? false
                                              : true,
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        bootomSheet()
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }

  Widget bootomSheet() {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: white, boxShadow: [
          BoxShadow(
            color: grey[350].withOpacity(0.95),
            spreadRadius: 0.5,
            blurRadius: 20,
          )
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            app.order.state.toLowerCase() == 'deliverd'
                ? Column(
                    children: [
                      Form(
                        key: formKey2,
                        child: TextFormField(
                          onSaved: (String v) =>
                              v.isNotEmpty ? promo = v : null,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none,
                              fillColor: greyw,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 12.0, bottom: 2),
                                child: Icon(
                                  Icons.local_offer_rounded,
                                  size: 35,
                                  color: red,
                                ),
                              ),
                              hintText: 'Add Promo Code',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Kprimary.withOpacity(0.35)),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.20),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$ ${calctotal()} ',
                      style: TextStyle(
                          color: red,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Delivary charge included',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.35),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Spacer(),
                app.order.state.toLowerCase() == 'deliverd'
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: PrimaryElevatedButton(
                            text: "RE ORDER",
                            onpressed: () async => await makeOrder()))
                    : Container()
              ],
            ),
          ],
        ));
  }

  makeOrder() async {
    if (position == null) {
      await getcurrantLocation();
      return;
    }
    formKey2.currentState.save();
    showDialogWidget(context);
    final reqData = {
      "userId": app.order.user.id,
      "state": "placed",
      "distLocation": [position.longitude, position.latitude],
      "items": app.order.items
          .map((e) => {"dishId": e.dish.id, "amount": e.amount})
          .toList()
    };

    final res = await API.makeOrder(reqData);

    if (res.statusCode == 200 || res.statusCode == 201) {
      app.reset();
      Navigator.of(context).pop();

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'ORDER',
        text: "Order completed successfully!",
        barrierDismissible: false,
        confirmBtnColor: Kprimary,
        onConfirmBtnTap: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Home()),
            (Route<dynamic> route) => false),
      );
    } else {
      Navigator.of(context).pop();
      showSnackbar(context: context, msg: 'something went wrong !!');
    }
  }

  String calctotal() {
    double sum = 0.0;
    app.order.items.forEach((e) {
      print(e.amount);
      sum += (e.dish.price * e.amount);
    });
    return sum.toString();
  }

  showSnackbar({msg, context, icon}) {
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(SnackBar(
      elevation: 2,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            msg,
            style: TextStyle(color: white.withOpacity(0.9), fontSize: 14),
          ),
          Icon(
            icon != null ? icon : Icons.error,
            color: icon != null ? white : red,
          ),
        ],
      ),
      backgroundColor: Kprimary,
    ));
  }
}
