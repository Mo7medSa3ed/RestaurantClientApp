import 'package:flutter/material.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/screans/alldishes.dart';

class TextRow extends StatelessWidget {
  final text;
  final show;
  final test;
  TextRow(this.text, {this.show, this.test});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
              color: Kprimary, fontSize: 24, fontWeight: FontWeight.w800),
        ),
        show
            ? GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AllDishScrean(test))),
                child: Text(
                  'View All',
                  style: TextStyle(
                      color: red, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : Container(),
      ],
    );
  }
}
