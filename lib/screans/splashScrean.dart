import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/home.dart';
import 'package:resturantapp/screans/loginScrean.dart';
import 'package:resturantapp/screans/pageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class SplashScrean extends StatefulWidget {
  @override
  _SplashScreanState createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  AppData appData;
  SharedPreferences prfs;
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
    if (networktest) {
      getData();
    }
  }

  getData() async {
    appData = Provider.of<AppData>(context, listen: false);
    prfs = await SharedPreferences.getInstance();
    if (prfs.getString('user') != null) {
      User user = await getUserFromPrfs();
      User u = (await API.getOneUser(user.id))['data'];

      if (u != null || u.updatedAt == user.updatedAt) {
        appData.initLoginUser(u);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScrean()));
      }
    } else {
      if (prfs.getBool('first') != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScrean()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => PageViewScrean()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: networktest
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: white,
              child: Image.asset("assets/images/splashscrean.png"))
          : noNetworkwidget(),
    );
  }
}
