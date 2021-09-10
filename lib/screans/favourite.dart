import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_dish_card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class FavouriteScrean extends StatefulWidget {
  @override
  _FavouriteScreanState createState() => _FavouriteScreanState();
}

class _FavouriteScreanState extends State<FavouriteScrean> {
  bool networktest = true;
  bool status = false;
  AppData app;
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      networktest = false;
    } else {
      networktest = true;
      fetchDate();
    }
    setState(() {});
  }

  @override
  void initState() {
    app = Provider.of<AppData>(context, listen: false);
    checkNetwork();
    super.initState();
  }

  Future<void> fetchDate() async {
    await API.getFavOrHis(fav: true, id: app.loginUser.id).then((value) {
      status = value['status'];
      if (value['status']) {
        app.initFavDishesList(value['data']);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width;
    return networktest
        ? ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            primary: true,
            children: [
                Text(
                  'My Favourite Item',
                  style: TextStyle(
                      color: Kprimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  height: hei > wid ? hei * 0.2 : hei * 0.25,
                  width: wid,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://cdnb.artstation.com/p/assets/images/images/025/858/179/large/ruchita-ghatage-food-poster.jpg?1587143002'),
                          alignment: Alignment.center,
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                (status && app.favDishes.length > 0)
                    ? Consumer<AppData>(builder: (ctx, app, c) {
                        if (app.favDishes.length == 0) {
                          return Container(
                              width: double.infinity,
                              height: hei - (hei * 0.4),
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/images/fav.png",
                                fit: BoxFit.cover,
                              ));
                        }
                        return FadeIn(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisExtent:
                                          hei > wid ? hei * 0.36 : hei * 0.55,
                                      mainAxisSpacing: 8),
                              itemCount: app.favDishes.length,
                              itemBuilder: (c, i) => PrimaryDishCard(
                                    radius: 10.0,
                                    rightMargin: 0.0,
                                    dish: app.favDishes[i],
                                    width: hei > wid
                                        ? wid * 0.5 - 26
                                        : wid * 0.45 - 26,
                                    height: hei > wid ? hei * 0.24 : hei * 0.32,
                                    isLiked: true,
                                    ontap: (b) async => await removetoFav(
                                        c, app.favDishes[i].id),
                                  )

                              // return GestureDetector(
                              //     onTap: () => Navigator.of(context)
                              //         .push(MaterialPageRoute(
                              //             builder: (_) => DetailsScrean(
                              //                   v.loginUser.fav[i],
                              //                 ))),
                              //     child: buildCardForDishes(
                              //       wid,
                              //       10.0,
                              //       context,
                              //       app.favDishes[i].img,
                              //       0.0,
                              //       hei > wid ? hei * 0.18 : hei * 0.4,
                              //       app.favDishes[i],
                              //       v.loginUser.fav.contains(app.favDishes[i].id),
                              //       (b) async => await addtoFav(
                              //           context, app.favDishes[i].id),
                              //     ));
                              ),
                        );
                      })
                    : (status && app.favDishes.length == 0)
                        ? Container(
                            width: double.infinity,
                            height: hei - (hei * 0.4),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/fav.png",
                              fit: BoxFit.cover,
                            ))
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
              ])
        : noNetworkwidget();
  }
}

                        


/**
 *  else {
                            return Container(
                                width: double.infinity,
                                height: (MediaQuery.of(context).size.height) -
                                    (MediaQuery.of(context).size.height * 0.4),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/fav.png",
                                  fit: BoxFit.cover,
                                ));
                          }
 */

/**
 * 
 * FadeIn(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                              child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisExtent: hei > wid
                                              ? hei * 0.36
                                              : hei * 0.55,
                                          mainAxisSpacing: 8),
                                  itemCount: app.favDishes.length,
                                  itemBuilder: (c, i) => PrimaryDishCard(
                                        radius: 10.0,
                                        rightMargin: 0.0,
                                        dish: app.favDishes[i],
                                        width: hei > wid
                                            ? wid * 0.5 - 26
                                            : wid * 0.45 - 26,
                                        height:
                                            hei > wid ? hei * 0.24 : hei * 0.32,
                                        isLiked: app.loginUser.fav
                                            .contains(app.favDishes[i].id),
                                        ontap: (b) async => await addtoFav(
                                            context, app.favDishes[i].id),
                                      )

                                  // return GestureDetector(
                                  //     onTap: () => Navigator.of(context)
                                  //         .push(MaterialPageRoute(
                                  //             builder: (_) => DetailsScrean(
                                  //                   v.loginUser.fav[i],
                                  //                 ))),
                                  //     child: buildCardForDishes(
                                  //       wid,
                                  //       10.0,
                                  //       context,
                                  //       app.favDishes[i].img,
                                  //       0.0,
                                  //       hei > wid ? hei * 0.18 : hei * 0.4,
                                  //       app.favDishes[i],
                                  //       v.loginUser.fav.contains(app.favDishes[i].id),
                                  //       (b) async => await addtoFav(
                                  //           context, app.favDishes[i].id),
                                  //     ));
                                  ),
                            )
 */