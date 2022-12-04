import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_cart_card.dart';
import 'package:resturantapp/components/primary_flatButton.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/loginScrean.dart';
import 'package:resturantapp/screans/updateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool login = true;
  AnimationController _controller;
  bool isArabic = false;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (ctx, v, c) => Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: v.loginUser.avatar == null
                          ? CircleAvatar(
                              backgroundColor: Kprimary.withOpacity(0.9),
                              child: Icon(
                                Icons.person,
                                color: white,
                                size: 30,
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                              v.loginUser.avatar ?? img
                              /*  v.loginUser.avatar
                                   */
                              ,
                            )),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.loginUser.name,
                          style: TextStyle(
                              color: black.withOpacity(0.8),
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                        Text(
                          v.loginUser.email,
                          style: TextStyle(
                              color: Kprimary.withOpacity(0.35),
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: 30,
                          color: Kprimary.withOpacity(0.4),
                        ),
                        onPressed: () {
                          _showModelSheet();
                        })
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                buildmovetabs(),
                SizedBox(
                  height: 20,
                ),
                !login
                    ? FadeTransition(
                        opacity: Tween<double>(begin: 0.1, end: 1.0)
                            .animate(_controller),
                        child: buildListForHistory())
                    : FadeTransition(
                        opacity: Tween<double>(begin: 0.1, end: 1.0)
                            .animate(_controller),
                        child: buildListForListTile(v.loginUser)),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: PrimaryFlatButton(
                text: 'LOGOUT',
                onPressed: () async {
                  SharedPreferences prfs =
                      await SharedPreferences.getInstance();
                  prfs.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginScrean()),
                      (Route<dynamic> route) => false);
                }),
          )
        ],
      ),
    );
  }

  buildListTileForProfile(title, val) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Kprimary.withOpacity(0.35),
            fontSize: 14,
            fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      dense: false,
      subtitle: Text(
        val,
        style: TextStyle(
            color: Kprimary.withOpacity(0.75),
            fontSize: 16,
            fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  buildListForListTile(User u) {
    return Column(
      children: [
        buildListTileForProfile('Full Name', u.name != null ? u.name : 'none'),
        buildListTileForProfile('Phone', u.phone != null ? u.phone : 'none'),
        buildListTileForProfile(
            'Address', u.address != null ? u.address : 'none'),
        buildListTileForProfile(
            'Location', u.location != null ? u.location : 'none'),
        buildListTileForProfile('Gender', u.gender != null ? u.gender : 'none'),
        buildListTileForProfile(
            'Date of Birth',
            u.dob != null
                ? DateFormat.yMMMMEEEEd('en_US').format(DateTime.parse(u.dob))
                : 'none'),
      ],
    );
  }

  buildListForHistory() {
    return FutureBuilder(
        future: API.getFavOrHis(
            fav: false,
            id: Provider.of<AppData>(context, listen: false).loginUser.id),
        builder: (ctx, s) {
          if (s.hasData) {
            if (s.data['status'] && s.data['data'].length > 0) {
              Provider.of<AppData>(context, listen: false)
                  .initHistoryDishesList(s.data['data']);

              return Consumer<AppData>(builder: (ctx, app, c) {
                return Column(
                    children: List.from(app.historyDishes
                        .map((e) => PrimaryCartCard(e, test: true))));
              });
            } else {
              return Center(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/List.png",
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                          ),
                          Text(
                            "Your History List is Empty",
                            style: TextStyle(color: grey, fontSize: 18),
                          )
                        ],
                      )));
            }
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Row buildmovetabs() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: login ? red : greyd, width: login ? 4 : 0.7))),
            child: GestureDetector(
              onTap: () {
                if (login == false) {
                  setState(() {
                    login = !login;
                  });
                  _controller.reset();
                  _controller.forward();
                }
              },
              child: Text(
                'About',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: Kprimary),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: login ? greyd : red, width: login ? 0.7 : 4))),
              child: GestureDetector(
                onTap: () {
                  if (login) {
                    setState(() {
                      login = !login;
                    });
                    _controller.reset();
                    _controller.forward();
                  }
                },
                child: Text(
                  ' History',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Kprimary),
                  textAlign: TextAlign.end,
                ),
              ),
            ))
      ],
    );
  }

  _showModelSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, s) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => UpdateProfile()));
                  },
                  title: Text("Edit Profile",
                      style: TextStyle(
                          color: Kprimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                ListTile(
                  title: Text("Arabic",
                      style: TextStyle(
                          color: Kprimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  trailing: CupertinoSwitch(
                      activeColor: Kprimary,
                      value: isArabic,
                      onChanged: (v) {
                        s(() {
                          isArabic = v;
                        });
                      }),
                )
              ],
            ),
          );
        });
  }
}
