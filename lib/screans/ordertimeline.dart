import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeLine extends StatefulWidget {
  @override
  _OrderTimeLineState createState() => _OrderTimeLineState();
}

class _OrderTimeLineState extends State<OrderTimeLine> {
  var markers = HashSet<Marker>();

  // getoneOrder() async {
  //   await API.getOneOrder(widget.id).then((value) {
  //     if (value['status']) {
  //       dislocation = value['data']['distLocation'];
  //       delivarylocation = value['data']['deliveryLocation'];
  //       state = value['data']['state'];
  //       setState(() {});
  //     }
  //   });
  // }

  Set<Polyline> mypolyline(dislocation, delivarylocation) {
    List<Polyline> polylineList = [];
    polylineList.add(Polyline(
        polylineId: PolylineId('${Random().nextDouble().toInt()}'),
        color: red,
        width: 5,
        points: [
          LatLng(dislocation[1], dislocation[0]),
          LatLng(delivarylocation[1], delivarylocation[0]),
        ],
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
        patterns: [PatternItem.dash(8), PatternItem.gap(5)]));

    return polylineList.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer<AppData>(builder: (ctx, app, c) {
        final dislocation = app.trackOrder.distLocation;
        final delivarylocation = app.trackOrder.deliveryLocation;
        final state = app.trackOrder.state;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                child: Stack(children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    mapToolbarEnabled: true,
                    trafficEnabled: true,
                    buildingsEnabled: true,
                    polylines: mypolyline(dislocation, delivarylocation),
                    initialCameraPosition: CameraPosition(
                      target: delivarylocation != null
                          ? LatLng(delivarylocation[1], delivarylocation[0])
                          : null,
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        markers.add(Marker(
                            markerId: MarkerId('${Random().nextInt(500)}'),
                            position: delivarylocation != null
                                ? LatLng(
                                    delivarylocation[1], delivarylocation[0])
                                : null,
                            infoWindow: InfoWindow(
                                title: 'Crepe Thawra',
                                snippet: 'this is shop location')));
                        markers.add(Marker(
                            markerId: MarkerId('${Random().nextInt(500)}'),
                            position: dislocation != null
                                ? LatLng(dislocation[1], dislocation[0])
                                : null,
                            infoWindow: InfoWindow(
                                title: 'Customer',
                                snippet: 'this is customer location')));
                      });
                    },
                    markers: markers,
                  ),
                  Positioned(
                      top: 8,
                      left: 10,
                      child: Container(
                        width: 50,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Kprimary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: Icon(
                            Icons.keyboard_backspace,
                            size: 20,
                            color: grey[300],
                          ),
                        ),
                      )),
                ]),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    // afterLineStyle: LineStyle(color: Kprimary),
                    indicatorStyle: IndicatorStyle(
                      width: 25,
                      color:
                          state.toString().toLowerCase().trim() == 'confirmed'
                              ? red
                              : Kprimary,
                    ),
                    isFirst: true,

                    endChild: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                          selected: false,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          title: Text(
                            "Order Confirmed",
                            style: TextStyle(
                                color: state.toString().toLowerCase().trim() ==
                                        'confirmed'
                                    ? red
                                    : Kprimary,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          leading: Image.asset(
                            'assets/images/order.png',
                            height: 35,
                          )),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    // afterLineStyle: LineStyle(color: Kprimary),
                    //beforeLineStyle: LineStyle(color: Kprimary),
                    indicatorStyle: IndicatorStyle(
                      width: 25,
                      color: state.toString().toLowerCase().trim() == 'onway'
                          ? red
                          : Kprimary,
                    ),
                    endChild: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                          selected: false,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          title: Text(
                            "Order On Way",
                            style: TextStyle(
                                color: state.toString().toLowerCase().trim() ==
                                        'onway'
                                    ? red
                                    : Kprimary,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          leading: Image.asset(
                            'assets/images/del.png',
                            height: 35,
                          )),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    isLast: true,
                    //beforeLineStyle: LineStyle(color: Kprimary),
                    indicatorStyle: IndicatorStyle(
                      width: 25,
                      color: state.toString().toLowerCase().trim() == 'ready'
                          ? red
                          : Kprimary,
                    ),
                    endChild: Container(
                      alignment: Alignment.center,
                      child: ListTile(
                          selected: false,
                          contentPadding: EdgeInsets.symmetric(horizontal: 30),
                          title: Text(
                            "Ready to pickup",
                            style: TextStyle(
                                color: state.toString().toLowerCase().trim() ==
                                        'ready'
                                    ? red
                                    : Kprimary,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          leading: Image.asset(
                            'assets/images/ready.png',
                            height: 35,
                          )),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      })),
    );
  }
}
/*   void makeLines() async {
    https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=AIzaSyBMD6TqYt-Y0dc4grEFzBmCkHOqsKncgAo"
 final l =await API.getRouteCoordinates(LatLng(30.5144865, 31.3542081),LatLng(30.51884163622735, 31.35213116299317));
 /*    GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: APIKEY);
    final List<LatLng> l = await googleMapPolyline
        .getCoordinatesWithLocation(
            origin: LatLng(40.677939, -73.941755),
            destination: LatLng(40.698432, -73.924038),
            mode: RouteMode.driving)
        .then((value) {
    });
       */
  } */