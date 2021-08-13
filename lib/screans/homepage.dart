import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/alldishes.dart';
import 'package:resturantapp/screans/details.dart';
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

  getData() async {
    AppData appData = Provider.of<AppData>(context, listen: false);
    await API.getAllDishes().then((value) => appData.initDishesList(value));
    await API
        .getAllCategories()
        .then((value) => appData.initCategoryList(value));
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
        final dishes = value.dishesList.where((e) => e.rating >= 5).toList();
        final popular = value.dishesList.where((e) => e.rating < 5).toList();

        return RefreshIndicator(
          onRefresh: () async => await getData(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              
              children: [
              buildRow('Dishes', '0'),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              value.dishesList.length > 0
                  ? FadeIn(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeIn,
                      child: Container(
                        height: hei > wid ? hei * 0.35 : hei * 0.48,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: dishes.length,
                            itemBuilder: (_, i) => GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => DetailsScrean(
                                                dishes[i].id,
                                              ))),
                                  child: buildCardForDishes(
                                      hei > wid ? wid * 0.85 : wid * 0.47,
                                      20.0,
                                      context,
                                      dishes[i].img,
                                      20.0,
                                      hei > wid ? hei * 0.24 : hei * 0.30,
                                      dishes[i],
                                      value.loginUser.fav
                                          .contains(dishes[i].id),
                                      (b) async => await addtoFav(
                                          context, dishes[i].id)),
                                )),
                      ),
                    )
                  : shimerForDishes(),
              Text(
                'Food Categories',
                style: TextStyle(
                    color: Kprimary, fontSize: 24, fontWeight: FontWeight.w800),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              value.categoryList.length > 0
                  ? FadeIn(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeIn,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: value.categoryList
                                .map((e) => GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AllDishScrean(e.name))),
                                      child: buildCardforCategory(c: e),
                                    ))
                                .toList()),
                      ),
                    )
                  : shimerForcategory(),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              buildRow('Our Popular Item', '1'),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              value.dishesList.length > 0
                  ? FadeIn(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeIn,
                      child: Container(
                        height: hei > wid ? hei * 0.34 : hei * 0.48,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: popular.length,
                          itemBuilder: (_, i) => GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (_) => DetailsScrean(
                                            popular[i].id,
                                          ))),
                              child: buildCardForDishes(
                                  hei > wid
                                      ? wid * 0.5 - 26
                                      : wid * 0.45 - 26,
                                  10.0,
                                  context,
                                  popular[i].img,
                                  20.0,
                                  hei > wid ? hei * 0.24 : hei * 0.32,
                                  popular[i],
                                  value.loginUser.fav.contains(popular[i].id),
                                  (b) async => await addtoFav(
                                      context, popular[i].id))),
                        ),
                      ),
                    )
                  : shimerForPopular(),
            ]),
          ),
        );
      },
    );
  }

  Widget shimerForDishes() {
    return Shimmer.fromColors(
      baseColor: grey.withOpacity(0.3),
      highlightColor: grey.withOpacity(0.45),
      child: Container(
        height: getProportionateScreenHeight(270),
        child: ListView.builder(
              physics: BouncingScrollPhysics(),

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

  Widget shimerForcategory() {
    return Shimmer.fromColors(
        baseColor: grey.withOpacity(0.3),
        highlightColor: grey.withOpacity(0.45),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: l.map((e) => buildCardforCategory()).toList()),
        ));
  }

  Widget shimerForPopular() {
    return Shimmer.fromColors(
        baseColor: grey.withOpacity(0.3),
        highlightColor: grey.withOpacity(0.45),
        child: Container(
          height: getProportionateScreenHeight(270),
          child: ListView.builder(
                         physics: BouncingScrollPhysics(),

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

  Widget buildRow(text, test) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Kprimary, fontSize: 24, fontWeight: FontWeight.w800),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AllDishScrean(test))),
          child: Text(
            'View All',
            style: TextStyle(
                color: red, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget buildCardforCategory({Categorys c}) {
    return Container(
      child: Card(
        shadowColor: Kprimary,
        elevation: 2,
        color: Colors.white.withOpacity(0.97),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.fastfood,
                color: red.withOpacity(0.7),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    c != null ? c.name : "",
                    style: TextStyle(
                        color: Kprimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  Text(
                    c != null ? '${c.numOfDishes} items' : '0 items',
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.3),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
