import 'package:flutter/material.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/screans/alldishes.dart';

class PrimaryCategoryCard extends StatelessWidget {
  final category;
  PrimaryCategoryCard(this.category);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AllDishScrean(category.name))),
        child: Card(
          shadowColor: Kprimary,
          elevation: 2,
          color: Colors.white.withOpacity(0.97),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fastfood,
                  color: red.withOpacity(0.7),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      category != null ? category.name : "",
                      style: TextStyle(
                          color: Kprimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    Text(
                      category != null
                          ? '${category.numOfDishes} items'
                          : '0 items',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.3),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
