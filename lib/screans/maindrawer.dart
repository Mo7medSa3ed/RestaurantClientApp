import 'package:flutter/material.dart';
import 'package:resturantapp/admin/allCategorysForAdmin.dart';
import 'package:resturantapp/admin/allDishesForAdmin.dart';
import 'package:resturantapp/admin/allUsersForAdmin.dart';
import 'package:resturantapp/admin/ordersPage.dart';
import 'package:resturantapp/constants.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
              physics: BouncingScrollPhysics(),

          children: [
            DrawerHeader(
                margin: EdgeInsets.all(0),
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: Kprimary, borderRadius: BorderRadius.circular(8)),
                  accountName: Text(
                    "Mohamed Saeed",
                    style: TextStyle(fontSize: 14),
                  ),
                  accountEmail: Text(
                    "mohamedsaeed@gmail.com",
                    style: TextStyle(fontSize: 12),
                  ),
                )),
            ListTile(
              title: Text("All Dishes"),
              onTap: () => go(AllDishesForAdminScrean(), context),
            ),
            ListTile(
              title: Text("All Users"),
              onTap: () => go(AllUsersForAdminScrean(), context),
            ),
            ListTile(
              title: Text("All Categories"),
              onTap: () => go(AllCategoriesForAdminScrean(), context),
            ),
            ListTile(
              title: Text("All Orders"),
              onTap: ()  => go(OrdersPage(), context),
            ),
          ],
        ),
      ),
    );
  }
}

go(screan, context) {
  Navigator.of(context).pop();
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => screan));
}
