import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_category_card.dart';
import 'package:resturantapp/components/primary_dish_card.dart';
import 'package:resturantapp/components/primary_text_row.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  var l = [1, 2, 3, 4, 5];
  bool networktest = true;
  bool status = false;
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      networktest = false;
    } else {
      networktest = true;
    }
    getData();
  }

  getData() async {
    AppData appData = Provider.of<AppData>(context, listen: false);
    await API.getHome().then((value) {
      status = value['status'];
      if (value['status']) appData.initHomeModel(value['data']);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: networktest ? body() : noNetworkwidget());
  }

  Widget body() {
    SizeConfig().init(context);
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width;
    return Consumer<AppData>(
      builder: (ctx, value, c) {
        final dishes = value.homeModel.topRate ?? [];
        final popular = value.homeModel.popular ?? [];
        final categoryList = value.homeModel.categories ?? [];

        return RefreshIndicator(
          onRefresh: () async => await getData(),
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: [
                TextRow('Dishes', test: '0', show: dishes.length > 6),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                (dishes.length > 0 && status)
                    ? FadeIn(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        child: Container(
                          height: hei > wid ? hei * 0.35 : hei * 0.5,
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: dishes.length,
                              itemBuilder: (_, i) => PrimaryDishCard(
                                    rightMargin: 20.0,
                                    dish: dishes[i],
                                    width: hei > wid ? wid * 0.85 : wid * 0.47,
                                    height: hei > wid ? hei * 0.24 : hei * 0.30,
                                    isLiked: value.loginUser.fav
                                        .contains(dishes[i].id),
                                    ontap: (b) async =>
                                        await addtoFav(context, dishes[i].id),
                                  )),
                        ),
                      )
                    : (status && dishes.length == 0)
                        ? SizedBox(
                            height: hei > wid ? hei * 0.24 : hei * 0.30,
                            child: Center(
                              child: emptyTextWidget,
                            ),
                          )
                        : shimerForDishes(hei, wid),
                Text(
                  'Food Categories',
                  style: TextStyle(
                      color: Kprimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                (categoryList.length > 0 && status)
                    ? FadeIn(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: categoryList
                                  .where((e) => e.numOfDishes >= 0)
                                  .map(
                                    (e) => PrimaryCategoryCard(e),
                                  )
                                  .toList()),
                        ),
                      )
                    : (status && categoryList.length == 0)
                        ? SizedBox(
                            height: 100,
                            child: Center(
                              child: emptyTextWidget,
                            ),
                          )
                        : shimerForcategory(hei, wid),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                TextRow('Our Popular Item',
                    test: '1', show: popular.length > 6),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                popular.length > 0
                    ? FadeIn(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        child: Container(
                          height: hei > wid ? hei * 0.36 : hei * 0.55,
                          child: ListView.builder(
                            itemExtent: wid / 2,
                            physics: AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: popular.length,
                            itemBuilder: (_, i) => PrimaryDishCard(
                              dish: popular[i],
                              width:
                                  hei > wid ? wid * 0.5 - 26 : wid * 0.45 - 26,
                              height: hei > wid ? hei * 0.24 : hei * 0.32,
                              isLiked:
                                  value.loginUser.fav.contains(popular[i].id),
                              ontap: (b) async =>
                                  await addtoFav(context, popular[i].id),
                            ),
                          ),
                        ),
                      )
                    : (status && popular.length == 0)
                        ? SizedBox(
                            height: hei > wid ? hei * 0.24 : hei * 0.32,
                            child: Center(
                              child: emptyTextWidget,
                            ),
                          )
                        : shimerForPopular(hei, wid),
              ]),
        );
      },
    );
  }

  Widget shimerForDishes(hei, wid) {
    return Shimmer.fromColors(
      baseColor: grey.withOpacity(0.3),
      highlightColor: grey.withOpacity(0.45),
      child: Container(
        height: hei > wid ? hei * 0.35 : hei * 0.48,
        child: ListView.builder(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: l.length,
          itemBuilder: (_, i) => cCardForDishes(
              MediaQuery.of(context).size.width * 0.85,
              20.0,
              context,
              20.0,
              MediaQuery.of(context).size.height * 0.24),
        ),
      ),
    );
  }

  Widget shimerForcategory(hei, wid) {
    return Shimmer.fromColors(
        baseColor: grey.withOpacity(0.3),
        highlightColor: grey.withOpacity(0.45),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: l.map((e) => PrimaryCategoryCard(null)).toList()),
        ));
  }

  Widget shimerForPopular(hei, wid) {
    return Shimmer.fromColors(
        baseColor: grey.withOpacity(0.3),
        highlightColor: grey.withOpacity(0.45),
        child: Container(
          height: hei > wid ? hei * 0.36 : hei * 0.55,
          child: ListView.builder(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: l.length,
            itemBuilder: (_, i) => cCardForDishes(
                (MediaQuery.of(context).size.width * 0.5) - 26,
                10.0,
                context,
                20.0,
                MediaQuery.of(context).size.height * 0.25),
          ),
        ));
  }
}
