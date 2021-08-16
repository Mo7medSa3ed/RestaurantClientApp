import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';

class PrimaryFlatButton extends StatelessWidget {
  final onPressed;
  final text;
  final id;

  const PrimaryFlatButton({this.onPressed, this.text, this.id});

  @override
  Widget build(BuildContext context) {
    AppData appdata = Provider.of<AppData>(context, listen: true);

    bool disable = appdata.cartList.map((e) => e.id).toList().contains(id);

    return Container(
        width: double.infinity,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(disable ? grey : red),
              padding: MaterialStateProperty.all(EdgeInsets.all(20))),
          onPressed: disable ? null : onPressed,
          child: Text(
            appdata.cartList.map((e) => e.id).toList().contains(id)
                ? 'Added To Cart !!'
                : text,
            style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
          ),
        ));
  }
}
