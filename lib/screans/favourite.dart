import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/components/primary_dish_card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class FavouriteScrean extends StatefulWidget {
  @override
  _FavouriteScreanState createState() => _FavouriteScreanState();
}

class _FavouriteScreanState extends State<FavouriteScrean> {
  bool networktest = true;
  // checkNetwork() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   print(connectivityResult);
  //   if (connectivityResult == ConnectivityResult.none) {
  //     networktest = false;
  //   } else {
  //     networktest = true;
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width;
    return networktest
        ? Consumer<AppData>(
            builder: (ctx, v, c) {
              List<Dish> favList = [];
              v.loginUser.fav.forEach((e) {
                final f = v.dishesList.firstWhere((element) => element.id == e,
                    orElse: () => null);
                if (f != null) {
                  favList.add(f);
                }
              });

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
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
                    favList.length > 0
                        ? FadeIn(
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
                                itemCount: favList.length,
                                itemBuilder: (c, i) => PrimaryDishCard(
                                      radius: 10.0,
                                      rightMargin: 0.0,
                                      dish: favList[i],
                                      width: hei > wid
                                          ? wid * 0.5 - 26
                                          : wid * 0.45 - 26,
                                      height:
                                          hei > wid ? hei * 0.24 : hei * 0.32,
                                      isLiked: v.loginUser.fav
                                          .contains(favList[i].id),
                                      ontap: (b) async => await addtoFav(
                                          context, favList[i].id),
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
                                //       favList[i].img,
                                //       0.0,
                                //       hei > wid ? hei * 0.18 : hei * 0.4,
                                //       favList[i],
                                //       v.loginUser.fav.contains(favList[i].id),
                                //       (b) async => await addtoFav(
                                //           context, favList[i].id),
                                //     ));
                                ),
                          )
                        : Container(
                            width: double.infinity,
                            height: (MediaQuery.of(context).size.height) -
                                (MediaQuery.of(context).size.height * 0.4),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/fav.png",
                              fit: BoxFit.cover,
                            ))
                  ],
                ),
              );
            },
          )
        : noNetworkwidget();
  }
}
