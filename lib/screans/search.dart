import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_search_card.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:connectivity/connectivity.dart';

class SearchScrean extends StatefulWidget {
  @override
  _SearchScreanState createState() => _SearchScreanState();
}

class _SearchScreanState extends State<SearchScrean> {
  var controller = TextEditingController();
  List<Dish> dishList = [];
  AppData appData;
  bool status = true;
  bool networktest = true;
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return networktest
        ? ListView(children: [
            Card(
              shadowColor: Kprimary,
              elevation: 1,
              margin: EdgeInsets.all(16),
              child: TextField(
                maxLines: 1,
                controller: controller,
                onChanged: (String v) async {
                  if (v.isNotEmpty) {
                    setState(() {
                      status = false;
                    });

                    final res = await API.searchForDish(v.trim());
                    status = res['status'];
                    dishList = res['data'];
                  } else {
                    status = true;
                    dishList = [];
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: 'Search here.....',
                    suffixIcon: controller.text.toString().isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  controller.clear();
                                  dishList = [];
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Kprimary,
                                )),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 22.0),
                            child: Icon(Icons.search),
                          ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    border: InputBorder.none),
              ),
            ),
            (dishList.length > 0 && status)
                ? ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    itemCount: dishList.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) => PrimarySearchCard(dishList[i]),
                  )
                : (dishList.length == 0 && status)
                    ? Center(
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/List.png",
                                  fit: BoxFit.fill,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                Text(
                                  "Your Dish List is Empty",
                                  style: TextStyle(color: grey, fontSize: 18),
                                )
                              ],
                            )))
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
          ])
        : noNetworkwidget();
  }
}
