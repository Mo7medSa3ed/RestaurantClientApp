import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primart_elevatedButtom.dart';
import 'package:resturantapp/components/primary_cart_card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widgets.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class CheckoutScrean extends StatefulWidget {
  @override
  _CheckoutScreanState createState() => _CheckoutScreanState();
}

class _CheckoutScreanState extends State<CheckoutScrean> {
  AppData app;
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String address;
  String promo;
  bool isExist = false;
  bool readOnly = false;
  bool validCoupon = false;
  Position position;
  double discount = 0.0;
  List<Address> addresses;

  getcurrantLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.requestPermission();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);

    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    app = Provider.of<AppData>(context, listen: false);
    getcurrantLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // bottomSheet: bootomSheet(),
      body: SafeArea(
        child: Consumer<AppData>(
            builder: (ctx, v, c) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CheckOut',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Icons.refresh,
                                  color: Kprimary.withOpacity(0.35),
                                  size: 30,
                                ),
                                onPressed: () => getcurrantLocation(),
                              )
                            ],
                          ),
                          Text(
                            app.loginUser.name,
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
                                : "No address determined",
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
                            children: app.cartList
                                .map((e) => PrimaryCartCard(e))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    bootomSheet()
                  ],
                )),
      ),
    );
  }

  Widget bootomSheet() {
    return Container(
        padding: EdgeInsets.all(10),
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
            Form(
              key: formKey2,
              child: TextFormField(
                onSaved: (String v) => v.isNotEmpty ? promo = v : null,
                keyboardType: TextInputType.text,
                readOnly: readOnly,
                validator: (String v) {
                  if (v == null || v.isEmpty) {
                    return 'please enter coupon !!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    fillColor: greyw,
                    suffixIcon: TextButton(
                        onPressed: validCoupon
                            ? null
                            : () async {
                                await checkCoupon();
                              },
                        child: Text(validCoupon ? "Done" : "Check Coupon",
                            style: TextStyle(fontSize: 12))),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 12.0, bottom: 2),
                      child: Icon(
                        Icons.local_offer_rounded,
                        size: 30,
                        color: red,
                      ),
                    ),
                    hintText: 'Add Promo Code',
                    hintStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Kprimary.withOpacity(0.35)),
                    filled: true),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
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
                        '\$ ${calctotal(discount)} ',
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
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: PrimaryElevatedButton(
                        text: "PLACE ORDER",
                        onpressed: () async => await makeOrder()))
              ],
            ),
          ],
        ));
  }

  checkCoupon() async {
    FocusScope.of(context).unfocus();

    formKey2.currentState.save();
    if (formKey2.currentState.validate()) {
      setState(() {
        readOnly = true;
      });
      showDialogWidget(context);
      final res = await API.verfiyCoupoun(promo.trim());
      Navigator.of(context).pop();

      if (res['status'] && res['data']['valid']) {
        setState(() {
          readOnly = true;
          validCoupon = true;
          discount = double.parse(res['data']['discount'].toString());
          FocusScope.of(context).unfocus();
        });
        return CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            title: 'Check Coupon',
            text: "Coupon is valid",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
      } else {
        setState(() {
          readOnly = false;
          validCoupon = false;
          FocusScope.of(context).unfocus();
        });
        return CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: 'Check Coupon',
            text: "Coupon is not valid",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
      }
    }
  }

  makeOrder() async {
    if (position == null) {
      await getcurrantLocation();
      return;
    }
    formKey2.currentState.save();
    showDialogWidget(context);
    final reqData = {
      "userId": app.loginUser.id,
      "state": "placed",
      "promo": promo,
      "distLocation": [position.longitude, position.latitude],
      "items":
          app.cartList.map((e) => {"dishId": e.id, "amount": e.amount}).toList()
    };

    final res = (await API.makeOrder(reqData));
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

  String calctotal(double discount) {
    double sum = 0.0;
    app.cartList.forEach((e) {
      sum += (e.price * e.amount);
    });
    return (sum - ((discount / 100) * sum)).toString();
  }

  showSnackbar({msg, context, icon}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
