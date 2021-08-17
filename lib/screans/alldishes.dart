import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_dish_card.dart';
import 'package:resturantapp/components/primary_flatButton.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:connectivity/connectivity.dart';

class AllDishScrean extends StatefulWidget {
  final String test;
  AllDishScrean(this.test);
  @override
  _AllDishScreanState createState() => _AllDishScreanState();
}

class _AllDishScreanState extends State<AllDishScrean> {
  AppData appData;
  bool isOldest = false;
  bool isSmallestRate = false;
  bool isSmallestPrice = false;
  bool islatest = false;
  bool isLargestRate = false;
  bool isLargestPrice = false;
  bool networktest = true;
  bool status = false;
  int page = 0;
  var list = [];
  bool isLast = false;
  final scrollController = ScrollController();

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
      appData.clearTopDishesList();
      appData.clearpopularDishesList();
      setState(() {});
    } else {
      page++;
    }
    if (isLast == false) {
      if (widget.test == '0') {
        await API.getAllDishes(top: true, page: page).then((value) {
          status = value['status'];
          if (value['status']) {
            if (value['data'].length < 6) {
              isLast = true;
            }
            appData.initTopDishesList(value['data']);
          }
        });
      } else if (widget.test == '1') {
        await API.getAllDishes(top: false, page: page).then((value) {
          status = value['status'];
          if (value['status']) {
            if (value['data'].length < 6) {
              isLast = true;
            }
            appData.initpopularDishesList(value['data']);
          }
        });
      } else {
        // await API.getAllDishes().then((value) => appData.initDishesList(value));
      }
      setState(() {});
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
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.test == '0'
                                  ? 'All Dishes'
                                  : widget.test == '1'
                                      ? 'All Popular Items'
                                      : 'All Dishes In ${widget.test}',
                              style: TextStyle(
                                  color: Kprimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5),
                              softWrap: false,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
                    child: RefreshIndicator(
                      onRefresh: () => fetchDate(true),
                      child: Consumer<AppData>(builder: (ctx, app, c) {
                        list = widget.test == "0"
                            ? app.topDishes
                            : widget.test == "1"
                                ? app.popularDishes
                                : app.dishesByCategory;

                        return (list.length > 0 && status)
                            ? GridView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: height > width
                                            ? (height / width).round()
                                            : (width / height).round() + 1,
                                        mainAxisExtent: height > width
                                            ? height * 0.35
                                            : height * 0.5,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 8),
                                itemCount: list.length,
                                itemBuilder: (c, i) => PrimaryDishCard(
                                      test: true,
                                      dish: list[i],
                                      width: height > width
                                          ? width * 0.5 - 26
                                          : width * 0.45 - 26,
                                      height: height > width
                                          ? height * 0.24
                                          : height * 0.32,
                                      isLiked: appData.loginUser.fav
                                          .contains(list[i].id),
                                      ontap: (b) async =>
                                          await addtoFav(context, list[i].id),
                                    ))
                            : (status && list.length == 0)
                                ? Center(
                                    child: emptyTextWidget,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                      }),
                    ),
                  )
                ],
              )
            : noNetworkwidget(),
      ),
    );
  }

  _showBottomSheet(context) {
    return showModalBottomSheet(
        isScrollControlled: true,
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
                    // SwitchListTile(
                    //     title: Text(
                    //       'Oldest',
                    //       style: TextStyle(fontWeight: FontWeight.w600),
                    //     ),
                    //     value: isOldest,
                    //     onChanged: (v) {
                    //       s(() {
                    //         isOldest = !isOldest;
                    //       });
                    //     }),
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
                    // SwitchListTile(
                    //     title: Text(
                    //       'Smallest Rate',
                    //       style: TextStyle(fontWeight: FontWeight.w600),
                    //     ),
                    //     value: isSmallestRate,
                    //     onChanged: (v) {
                    //       s(() {
                    //         isSmallestRate = !isSmallestRate;
                    //       });
                    //     }),
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
                    // SwitchListTile(
                    //     title: Text(
                    //       'Smallest Price',
                    //       style: TextStyle(fontWeight: FontWeight.w600),
                    //     ),
                    //     value: isSmallestPrice,
                    //     onChanged: (v) {
                    //       s(() {
                    //         isSmallestPrice = !isSmallestPrice;
                    //       });
                    //     }),
                    PrimaryFlatButton(
                        text: 'OK',
                        onPressed: () {
                          Navigator.pop(c);
                          if (!((islatest && isOldest) &&
                              (isLargestPrice && isSmallestPrice) &&
                              (isLargestRate && isSmallestRate))) {
                            if (isOldest) {
                              list.sort(
                                  (a, b) => a.updatedAt.compareTo(b.updatedAt));
                            } else if (!isOldest) {
                              list.sort(
                                  (a, b) => b.updatedAt.compareTo(a.updatedAt));
                            } else if (isLargestPrice) {
                              list.sort((a, b) => b.price.compareTo(a.price));
                            } else if (!isLargestPrice) {
                              list.sort((a, b) => a.price.compareTo(b.price));
                            } else if (isLargestRate) {
                              list.sort((a, b) => b.rating.compareTo(a.rating));
                            } else if (!isLargestRate) {
                              list.sort((a, b) => a.rating.compareTo(b.rating));
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
