import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return networktest?  appData.dishesList.length > 0
        ? Column(
            children: [
              Card(
                shadowColor: Kprimary,
                elevation: 1,
                margin: EdgeInsets.all(16),
                child: TextField(
                  maxLines: 1,
                  controller: controller,
                  onChanged: (String v) {
                    if (v.isNotEmpty) {
                      dishList = appData.dishesList
                          .where((e) => e.name
                              .toLowerCase()
                              .trim()
                              .contains(v.toLowerCase().trim()))
                          .toList();
                    } else {
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
              ListView.builder(
                physics: ClampingScrollPhysics(),
                itemCount: dishList.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) => buildListTile(dishList[i], ctx),
              )
            ],
          )
        : Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/List.png",
                      fit: BoxFit.fill,
                      height: 360,
                      width: 360,
                    ),
                    Text(
                      "Your Dish List is Empty",
                      style: TextStyle(color: grey, fontSize: 18),
                    )
                  ],
                )),
          ):noNetworkwidget();
  }
}
