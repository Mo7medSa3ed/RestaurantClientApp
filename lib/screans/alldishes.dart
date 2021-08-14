import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/details.dart';
import 'package:connectivity/connectivity.dart';

class AllDishScrean extends StatefulWidget {
  final String test;
  AllDishScrean(this.test);
  @override
  _AllDishScreanState createState() => _AllDishScreanState();
}

class _AllDishScreanState extends State<AllDishScrean> {
  AppData appData;
  List<Dish> datalist = [];
  bool isOldest = false;
  bool isSmallestRate = false;
  bool isSmallestPrice = false;
  bool islatest = false;
  bool isLargestRate = false;
  bool isLargestPrice = false;
  bool networktest = true;
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      networktest = false;
    } else {
      networktest = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
    appData = Provider.of<AppData>(context, listen: false);
    if (widget.test == '0') {
      datalist = appData.dishesList;
    } else if (widget.test == '1') {
      datalist = appData.dishesList.where((e) => e.rating < 5).toList();
    } else {
      datalist =
          appData.dishesList.where((e) => e.category == widget.test).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: networktest
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Row(
                        children: [
                          Text(
                            widget.test == '0'
                                ? 'All Dishes'
                                : widget.test == '1'
                                    ? 'All Popular Items'
                                    : 'All Dishes In ${widget.test}',
                            style: TextStyle(
                                color: Kprimary,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(
                                Icons.filter_alt_sharp,
                                size: 30,
                                color: Kprimary.withOpacity(0.5),
                              ),
                              onPressed: () => _showBottomSheet(context))
                        ],
                      )),
                  Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: height > width
                                ? (height / width).round()
                                : (width / height).round() + 1,
                            crossAxisSpacing: 16,
                          //  childAspectRatio: height > width ? 0.95 : 1,
                            mainAxisSpacing: 8),
                        itemCount: datalist.length,
                        itemBuilder: (c, i) {
                          return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => DetailsScrean(
                                            appData.loginUser.fav[i],
                                          ))),
                              child: buildCardForDishes(
                                  width,
                                  10.0,
                                  context,
                                  datalist[i].img,
                                  0.0,
                                  height > width
                                      ? height * 0.20
                                      : height * 0.35,
                                  datalist[i],
                                  appData.loginUser.fav
                                      .contains(datalist[i].id),
                                  (b) async =>
                                      await addtoFav(context, datalist[i].id),
                                  test: true));
                        }),
                  )
                ],
              )
            : noNetworkwidget(),
      ),
    );
  }

  _showBottomSheet(context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        isDismissible: false,
        elevation: 5,
        context: context,
        builder: (c) => StatefulBuilder(
              builder: (b, s) => Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SwitchListTile(
                        title: Text(
                          'Latest',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = !islatest;
                          });
                        }),
                    SwitchListTile(
                        title: Text(
                          'Oldest',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: isOldest,
                        onChanged: (v) {
                          s(() {
                            isOldest = !isOldest;
                          });
                        }),
                    SwitchListTile(
                        title: Text(
                          'Largest Rate',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: isLargestRate,
                        onChanged: (v) {
                          s(() {
                            isLargestRate = !isLargestRate;
                          });
                        }),
                    SwitchListTile(
                        title: Text(
                          'Smallest Rate',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: isSmallestRate,
                        onChanged: (v) {
                          s(() {
                            isSmallestRate = !isSmallestRate;
                          });
                        }),
                    SwitchListTile(
                        title: Text(
                          'Largest Price',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: isLargestPrice,
                        onChanged: (v) {
                          s(() {
                            isLargestPrice = !isLargestPrice;
                          });
                        }),
                    SwitchListTile(
                        title: Text(
                          'Smallest Price',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: isSmallestPrice,
                        onChanged: (v) {
                          s(() {
                            isSmallestPrice = !isSmallestPrice;
                          });
                        }),
                    buildFlatbutton(
                        text: 'OK',
                        context: c,
                        onpressed: () {
                          Navigator.pop(c);
                          if (!((islatest && isOldest) &&
                              (isLargestPrice && isSmallestPrice) &&
                              (isLargestRate && isSmallestRate))) {
                            if (isOldest) {
                              datalist.sort(
                                  (a, b) => a.updatedAt.compareTo(b.updatedAt));
                            } else if (islatest) {
                              datalist.sort(
                                  (a, b) => b.updatedAt.compareTo(a.updatedAt));
                            } else if (isLargestPrice) {
                              datalist
                                  .sort((a, b) => b.price.compareTo(a.price));
                            } else if (isSmallestPrice) {
                              datalist
                                  .sort((a, b) => a.price.compareTo(b.price));
                            } else if (isLargestRate) {
                              datalist
                                  .sort((a, b) => b.rating.compareTo(a.rating));
                            } else if (isSmallestRate) {
                              datalist
                                  .sort((a, b) => a.rating.compareTo(b.rating));
                            }
                          }

                          setState(() {});
                        }),
                  ],
                ),
              ),
            ));
  }
}
