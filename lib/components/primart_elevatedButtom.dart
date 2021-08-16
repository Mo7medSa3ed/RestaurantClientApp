import 'package:flutter/material.dart';
import 'package:resturantapp/constants.dart';

class PrimaryElevatedButton extends StatelessWidget {
  final onpressed;
  final text;

  const PrimaryElevatedButton({this.onpressed, this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
          padding: MaterialStateProperty.all(EdgeInsets.all(14))),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: greyw, fontSize: 18),
        ),
      ),
    );
  }
}
