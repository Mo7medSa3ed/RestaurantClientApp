import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustumTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obsecure;
  final Function onchanged;
  final Function onsaved;
  final Function validator;
  final String value;
  final int v;

  CustumTextField(
      {this.hint,
      this.icon,
      this.obsecure,
      this.onchanged,
      this.validator,
      this.onsaved,
      this.v,
      this.value});

  @override
  _CustumTextFieldState createState() => _CustumTextFieldState();
}

class _CustumTextFieldState extends State<CustumTextField> {
  bool shadow = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: white,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  )
                ]
              : null,
          borderRadius: BorderRadius.circular(8),
          color: grey.withOpacity(0.05)),
      child: Focus(
        onFocusChange: (f) {
          setState(() {
            shadow = f;
          });
        },
        child: TextFormField(
          // style: TextStyle(color: Kprimary),
          validator: widget.validator,
          onChanged: widget.onchanged,
          onSaved: widget.onsaved,
          initialValue: widget.value,
          maxLines: widget.v == 0 ? 5 : 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500, letterSpacing: 1, fontSize: 14),
              prefixIcon: Icon(
                widget.icon,
                size: 25,
              )),
          obscureText: widget.obsecure,
          inputFormatters:
              widget.v == 1 ? [FilteringTextInputFormatter.digitsOnly] : null,
          keyboardType: widget.hint.toLowerCase() == 'email'
              ? TextInputType.emailAddress
              : widget.hint.toLowerCase() == 'phone'
                  ? TextInputType.phone
                  : widget.v == 1
                      ? TextInputType.number
                      : TextInputType.text,
        ),
      ),
    );
  }
}

noNetworkwidget() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: grey[300].withOpacity(0.67),
    child: Image.asset('assets/images/net.png'),
  );
}

showDialogWidget(context) {
  CoolAlert.show(
    context: context,
    animType: CoolAlertAnimType.scale,
    type: CoolAlertType.loading,
    text: "loading please wait....",
    barrierDismissible: false,
  );
}

saveUserToshared(user, context) async {
  final prfs = await SharedPreferences.getInstance();
  prfs.setString('user', user);
}

saveUsertoAppdata(user, context) {
  AppData appdata = Provider.of<AppData>(context, listen: false);
  final parsed = json.decode(user);
  User u = User.fromJson(parsed);
  appdata.initLoginUser(u);
}

showSnackbarWidget({msg, context, icon}) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    animType: CoolAlertAnimType.scale,
    confirmBtnColor: red,
    title: 'Error',
    text: "some thing went error !!",
    barrierDismissible: false,
  );
}

cCardForDishes(width, double c, context, m, height) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.only(right: m),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(c),
          color: black,
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        'Thai beef fried rice',
        style: TextStyle(
            color: Kprimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            backgroundColor: black),
      ),
      SizedBox(
        height: 10,
      ),
      RatingBar.builder(
        onRatingUpdate: null,
        updateOnDrag: false,
        ignoreGestures: true,
        itemSize: 16,
        initialRating: 5,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber[800],
        ),
      ),
    ],
  );
}

Future<bool> addtoFav(context, dishid) async {
  AppData appdata = Provider.of<AppData>(context, listen: false);
  API.addanddelteFav(appdata.loginUser.id, dishid);
  if (appdata.loginUser.fav.contains(dishid)) {
    appdata.removeFromFavWithId(dishid);
    return false;
  } else {
    appdata.addToFav(dishid);
    return true;
  }
  // if (res.statusCode == 200 || res.statusCode == 201) {
  // }
}
