import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/admin/allUsersTable.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/user.dart';

class AllUsersForAdminScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: greyw),
        backgroundColor: Kprimary.withOpacity(0.9),
        title: Text(
          "All Users",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<User>>(
            future: API.getAllUser(),
            builder: (c, s) {
              if (s.hasData) {
                return AllUsersTable(
                  userlist: s.data,
                );
              } else {
                return Center(
                  child: SpinKitCircle(
                    color: Kprimary,
                  ),
                );
              }
            }),
      ),
    );
  }
}
