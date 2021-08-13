import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/admin/allorders.dart';
import 'package:resturantapp/screans/cart.dart';
import 'package:resturantapp/screans/favourite.dart';
import 'package:resturantapp/screans/homepage.dart';
import 'package:resturantapp/screans/profile.dart';
import 'package:resturantapp/screans/search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AppData appData;
  // Animation animation;
  // AnimationController controller;
  List<Widget> pages = [
    HomePage(),
    FavouriteScrean(),
    SearchScrean(),
    CartScrean(),
    Profile(),
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    // controller = AnimationController(
    //   duration: const Duration(milliseconds: 2000),
    //   vsync: this,
    // );
    //  Tween(begin: 0, end: MediaQuery.of(context).size.width*0.6,).animate(controller);
    getData();
  }

  getData() async {
    appData = Provider.of<AppData>(context, listen: false);
    await API.getAllDishes().then((value) => appData.initDishesList(value));
    await API
        .getAllCategories()
        .then((value) => appData.initCategoryList(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.97),
          unselectedItemColor: Kprimary,
          selectedItemColor: red,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
          ]),
      appBar: AppBar(
        backgroundColor: index == 0 ? white : null,
        /*  automaticallyImplyLeading: false, */
        /* leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Kprimary.withOpacity(0.5),
          ),
          onPressed: () {},
        ) */
        // leadingWidth: MediaQuery.of(context).size.width * 0.9,
        // leading: Container(
        //     child: Image.asset(
        //   "assets/images/del.png",
        // )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.list_alt,
              color: Kprimary.withOpacity(0.5),
            ),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AllOrdersScrean())),
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Kprimary.withOpacity(0.5),
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: pages[index],
    );
  }
}
