import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class OrderDetailsScrean extends StatefulWidget {
  final id;
  OrderDetailsScrean(this.id);
  @override
  _OrderDetailsScreanState createState() => _OrderDetailsScreanState();
}

class _OrderDetailsScreanState extends State<OrderDetailsScrean> {
  AppData app;
  User user;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isExist = false;
  Position position ;
  List<Address> addresses ;

  getcurrantLocation(dish) async {
    final coordinates =
        new Coordinates(dish['distLocation'][0], dish['distLocation'][1]);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {});
  }

  g() async {
    await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();
    await Geolocator.checkPermission();
  }

  @override
  void initState() {
    super.initState();
    g();
    app = Provider.of<AppData>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white.withOpacity(0.97),
      body: SafeArea(
        child: FutureBuilder(
          future: API.getOneOrder(widget.id),
          builder: (c, v) {
            if (v.hasData) {
              final dish = v.data;
              user = app.usersList.firstWhere((e) => e.id == dish['deliveryId'],
                  orElse: () => null);
              getcurrantLocation(dish);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<AppData>(
                    builder: (ctx, v, c) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'CUSTOMER ADDRESS',
                                          style: TextStyle(
                                              color: Kprimary.withOpacity(0.7),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${addresses == null ? "address loading please wait..... " : addresses.first.addressLine}",
                                      style: TextStyle(
                                          color: Kprimary.withOpacity(0.35),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 30,
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
                                      children: dish['items']
                                          .map<Widget>((e) => foodCard(e))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.70),
                                  spreadRadius: 1.5,
                                  blurRadius: 8,
                                ),
                              ], borderRadius: BorderRadius.circular(10)),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/del.png' /* dish['items']
                                                      [0]['dish']['img']
                                                  .toString()
                                                  .replaceAll('http', 'https') */
                                                  ),
                                              fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mohamed Saeed', //'${user.name}',
                                          style: TextStyle(
                                              color: Kprimary.withOpacity(0.8),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '01017030127', // '${user.phone}',
                                          style: TextStyle(
                                              color: Kprimary.withOpacity(0.4),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          '\$ ${dish['sum']} ',
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
                                    Container(
                                        alignment: Alignment.center,
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            color: red,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "${dish['state'].toString().toUpperCase()}",
                                          style: TextStyle(
                                              color: greyw2, fontSize: 18),
                                        ))
                                  ],
                                ),
                              ],
                            )
                          ],
                        )),
              );
            } else {
              return SpinKitCircle(
                color: Kprimary,
              );
            }
          },
        ),
      ),
    );
  }

  Widget foodCard(d) {
    return Container(
      width: double.infinity,
      height: 102,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        d['dish']['img'].replaceAll('http', 'https')),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d['dish']['name'],
                style: TextStyle(
                    color: Kprimary, fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBar.builder(
                    onRatingUpdate: (v){},
                    itemSize: 14,
                    initialRating: d['dish']['rating'].toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber[800],
                    ),
                  ),
                  Text(
                    '(${d['dish']['reviews'].length} review)',
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${d['dish']['numOfPieces']} Pieces',
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    '\$ ${d['dish']['price']}',
                    style: TextStyle(
                        color: red, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Container(
                width: (MediaQuery.of(context).size.width) - 188,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.indeterminate_check_box_outlined,
                      color: Kprimary.withOpacity(0.35),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${d['amount']}'),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.add_box_outlined,
                      color: Kprimary.withOpacity(0.35),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /*  makeOrder() async {
    if (position == null) {
      await getcurrantLocation();
      return;
    }
    formKey2.currentState.save();
    showDialogWidget(context);
    final reqData = {
      "userId": app.loginUser.id,
      "state": "placed",
      "distLocation": [position.longitude, position.latitude],
      "items":
          app.cartList.map((e) => {"dishId": e.id, "amount": e.amount}).toList()
    };

    final res = await API.makeOrder(reqData);

    if (res.statusCode == 200 || res.statusCode == 201) {
      app.cartList = [];
      app.address = null;
      app.notifyListeners();
      Navigator.of(context).pop();

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: 'ORDER',
        text: "Order completed successfully!",
        barrierDismissible: false,
        //flareAnimationName: "static",
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
    app.cartList.forEach((e) {
      sum += (e.price * e.amount);
    });
    return sum.toString();
  }

  showSnackbar({msg, context, icon}) {
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
 */
}
