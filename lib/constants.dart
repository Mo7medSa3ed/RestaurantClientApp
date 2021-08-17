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

const String img =
    'https://st.depositphotos.com/2101611/4338/v/600/depositphotos_43381243-stock-illustration-male-avatar-profile-picture.jpg';
const String emptyText = 'No Data Found';
const emptyTextWidget = Text(
  emptyText,
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
);
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

Future<User> getUserFromPrfs() async {
  SharedPreferences prfs = await SharedPreferences.getInstance();
  final parsed = json.decode(prfs.getString("user"));
  return User.fromJson(parsed);
}
