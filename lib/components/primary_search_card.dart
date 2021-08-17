import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/screans/details.dart';

class PrimarySearchCard extends StatelessWidget {
  final dish;
  const PrimarySearchCard(this.dish);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DetailsScrean(
                dish.id,
              ))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    minRadius: 30,
                    backgroundImage:
                        NetworkImage(dish.img),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: TextStyle(
                            color: Kprimary.withOpacity(0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            onRatingUpdate: null,
                            updateOnDrag: false,
                            ignoreGestures: true,
                            itemSize: 14,
                            initialRating: dish.rating.toDouble(),
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
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            ('(${dish.numOfPieces} pieces)'),
                            style: TextStyle(
                                color: Kprimary.withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    ('\$ ${dish.price}\t'),
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.90),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
