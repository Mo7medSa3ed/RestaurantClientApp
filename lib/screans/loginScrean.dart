import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/special.dart';
import 'package:resturantapp/screans/loginbody.dart';
import 'package:resturantapp/screans/signupbody.dart';
import 'package:resturantapp/size_config.dart';
import 'package:connectivity/connectivity.dart';

class LoginScrean extends StatefulWidget {
  @override
  _LoginScreanState createState() => _LoginScreanState();
}

class _LoginScreanState extends State<LoginScrean> {
  String email, password, username;
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
        child: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.grey[400],
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      )),
      body: networktest
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(28),
                    vertical: getProportionateScreenHeight(20)),
                child: Selector<Specials, bool>(
                  selector: (c, s) => s.isSignup,
                  builder: (ctx, v, c) => Column(
                    children: [
                      buildmovetabs(v),
                      v ? LoginBody() : SignupBody()
                    ],
                  ),
                ),
              ),
            )
          : noNetworkwidget(),
    );
  }

  Row buildmovetabs(v) {
    return Row(
      children: [
        Expanded(
    
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: v ? red : greyd, width: v ? 4 : 0.7))),
            child: Text(
              'Sign In',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w900, color: Kprimary),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
    
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: v ? greyd : red, width: v ? 0.7 : 4))),
              child: Text(
                ' Register',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w900, color: Kprimary),
                textAlign: TextAlign.end,
              ),
            ))
      ],
    );
  }
}
