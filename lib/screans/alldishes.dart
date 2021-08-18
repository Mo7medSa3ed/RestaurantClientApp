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
  final catId;
  AllDishScrean(this.test, {this.catId});
  @override
  _AllDishScreanState createState() => _AllDishScreanState();
}

class _AllDishScreanState extends State<AllDishScrean> {
  AppData appData;

  int islatest = 0;

  var networktest = true;
  bool status = false;
  int page = 0;
  var list = [];
  bool isLast = false;
  final scrollController = ScrollController();

  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
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
        await API
            .getAllDishesByCategory(widget.catId, page: page)
            .then((value) {
          status = value['status'];
          if (value['status']) {
            if (value['data'].length < 6) {
              isLast = true;
            }
            appData.initDishesByCategory(value['data']);
          }
        });
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
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
                    RadioListTile(
                        groupValue: 0,
                        title: Text(
                          'Latest',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = 0;
                          });
                        }),
                    RadioListTile(
                        groupValue: 1,
                        title: Text(
                          'Oldest',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = 1;
                          });
                        }),
                    RadioListTile(
                        groupValue: 2,
                        title: Text(
                          'Largest Rate',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = 2;
                          });
                        }),
                    RadioListTile(
                        groupValue: 3,
                        title: Text(
                          'Smallest Rate',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = 3;
                          });
                        }),
                    RadioListTile(
                        groupValue: 4,
                        title: Text(
                          'Largest Price',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = 4;
                          });
                        }),
                    RadioListTile(
                        groupValue: 5,
                        title: Text(
                          'Smallest Price',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: islatest,
                        onChanged: (v) {
                          s(() {
                            islatest = 5;
                          });
                        }),
                    PrimaryFlatButton(
                        text: 'OK',
                        onPressed: () {
                          Navigator.pop(c);
                          if (islatest == 0) {
                            list.sort(
                                (a, b) => b.updatedAt.compareTo(a.updatedAt));
                          } else if (islatest == 1) {
                            list.sort(
                                (b, a) => b.updatedAt.compareTo(a.updatedAt));
                          } else if (islatest == 2) {
                            list.sort((a, b) => b.rating.compareTo(a.rating));
                          } else if (islatest == 3) {
                            list.sort((b, a) => b.rating.compareTo(a.rating));
                          } else if (islatest == 4) {
                            list.sort((a, b) => b.price.compareTo(a.price));
                          } else if (islatest == 5) {
                            list.sort((b, a) => b.price.compareTo(a.price));
                          }

                          setState(() {});
                        }),
                  ],
                ),
              ),
            ));
  }
}
