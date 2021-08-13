import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/updateProfile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool login = true;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (ctx, v, c) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 75,
                          height: 70,
                          child: v.loginUser.avatar != null
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
                                      .replaceAll('http', 'https') */
                                  ,
                                )),
                        ),
                        SizedBox(
                          width: 20,
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
                              Icons.edit,
                              size: 30,
                              color: Kprimary.withOpacity(0.4),
                            ),
                            onPressed: () => Navigator.of(ctx).push(
                                MaterialPageRoute(
                                    builder: (_) => UpdateProfile())))
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
                            child: buildListForHistory(v.loginUser.history))
                        : FadeTransition(
                            opacity: Tween<double>(begin: 0.1, end: 1.0)
                                .animate(_controller),
                            child: buildListForListTile(v.loginUser)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: buildFlatbutton(
                text: 'LOGOUT',
                context: context,
                onpressed: () async {
                  /*      SharedPreferences prfs =
                      await SharedPreferences.getInstance();
                  prfs.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginScrean()),
                      (Route<dynamic> route) => false); */
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

  buildListForHistory(List<Dish> list) {
    return Column(
        children: list.length > 0
            ? list.map((e) => buildCardForCart(context, d: e, t: true)).toList()
            : []);
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
            child: InkWell(
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
              child: InkWell(
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

  io() {
    IO.Socket socket = IO.io('http://localhost:8082',
        IO.OptionBuilder().setTransports(['websocket']).build());
    socket.connect();
    // socket.on("newDish", (data) => print("Mohamed Saeed Add dish"));
  }
}
