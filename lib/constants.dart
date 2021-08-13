import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:resturantapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Kprimary = Color.fromRGBO(0, 8, 51, 1);
final white = Colors.white;
final black = Colors.black;
final grey = Colors.grey;
final greyw = Colors.grey[200];
final greyw2 = Colors.grey[300];
final greyd = Colors.grey[700];
final red = Color.fromRGBO(255, 32, 32, 1);
final blue = Colors.indigo[900];

//const String img =
  //  'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/20190503-delish-pineapple-baked-salmon-horizontal-ehg-450-1557771120.jpg';


const String img ='https://scontent.faly3-2.fna.fbcdn.net/v/t1.0-9/165116405_2885979808325881_6166312209592797239_n.jpg?_nc_cat=110&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=IWAs4e_vNmkAX8P1nlj&_nc_oc=AQkKodVsxaGg6IVQLv7Ir-ngo5-dR-JHig6s76WmaDeCobO_bowGyK2L13g7fV-0XbU&_nc_ht=scontent.faly3-2.fna&oh=6320e92abe5e9f7829dcccbfbbef69fe&oe=6086170E';

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

Future<User> getUserFromPrfs() async {
  SharedPreferences prfs = await SharedPreferences.getInstance();
  final parsed = json.decode(prfs.getString("user"));
  return User.fromJson(parsed);
}


