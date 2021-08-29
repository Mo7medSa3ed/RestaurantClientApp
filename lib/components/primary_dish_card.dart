import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/screans/details.dart';

class PrimaryDishCard extends StatelessWidget {
  final height;
  final width;
  final rightMargin;
  final ontap;
  final isLiked;
  final dish;
  final test;
  final radius;

  PrimaryDishCard(
      {this.dish,
      this.height,
      this.isLiked,
      this.ontap,
      this.rightMargin = 0.0,
      this.test = false,
      this.radius = 20.0,
      this.width});

  @override
  Widget build(BuildContext context) {
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DetailsScrean(
                dish.id,
              ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(right: rightMargin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: height,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Image.network(
                        dish.img != null ? dish.img : img,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, c, p) {
                          if (p == null) return c;
                          return Container(
                              width: width,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
                        },
                      )),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      maxRadius: hei > wid ? 22 : 20,
                      minRadius: hei > wid ? 22 : 20,
                      backgroundColor: grey[100],
                      child: Center(
                        child: LikeButton(
                          onTap: ontap,
                          isLiked: isLiked,
                          likeBuilder: (bool isLiked) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 2, right: 0, top: 2.5),
                              child: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? red : grey,
                                size: hei > wid ? 22 : 20,
                              ),
                            );
                          },
                          circleColor: CircleColor(start: red, end: red),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: red,
                            dotSecondaryColor: red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            dish.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Kprimary, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 2,
          ),
          RatingBar.builder(
            onRatingUpdate: null,
            updateOnDrag: false,
            ignoreGestures: true,
            itemSize: 16,
            initialRating: dish.rating.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.only(right: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber[800],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              width > wid * 0.5
                  ? Text(
                      dish.category['name'] ?? '',
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.35),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  : Expanded(
                      child: Text(
                        dish.category['name'] ?? '',
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            color: Kprimary.withOpacity(0.35),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
              SizedBox(
                width: 20,
              ),
              test
                  ? Text(
                      '\$ ${dish.price}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
