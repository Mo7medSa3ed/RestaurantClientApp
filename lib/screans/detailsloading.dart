import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:shimmer/shimmer.dart';

class DetailsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: grey.withOpacity(0.2), //0.2
        highlightColor: grey.withOpacity(0.2), //0.45
        enabled: false,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      cCardForDishes(
                          (MediaQuery.of(context).size.width),
                          25.0,
                          context,
                          0.0,
                          MediaQuery.of(context).size.height * 0.24),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '5 Pieces',
                            style: TextStyle(
                                color: Kprimary.withOpacity(0.3),
                                fontSize: 16,
                                backgroundColor: black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            '\$ 90',
                            style: TextStyle(
                                color: red,
                                fontSize: 16,
                                backgroundColor: black,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Product Descriptions',
                        style: TextStyle(
                            color: Kprimary,
                            fontSize: 18,
                            backgroundColor: black,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of',
                        style: TextStyle(
                            color: Kprimary.withOpacity(0.3),
                            fontSize: 14,
                            backgroundColor: black,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Reviews',
                        style: TextStyle(
                            color: Kprimary,
                            fontSize: 18,
                            backgroundColor: black,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildReviewCard(),
                      buildReviewCard(),
                      buildReviewCard(),
                      buildReviewCard(),
                      buildReviewCard(),
                      Container(
                        margin: EdgeInsets.only(
                            left: 12, right: 12, top: 12, bottom: 0),
                        child: TextField(
                          enabled: true,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          maxLength: 300,
                          maxLines: 3,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: grey),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 2, color: Kprimary),
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'Add New Review....'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              itemSize: 24,
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber[800],
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            /* Text(
                          '(25 review)',
                          style: TextStyle(
                              color: Kprimary.withOpacity(0.35),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),) */

                            IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 35,
                                ),
                                onPressed: () {})
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(onPressed: null, child: null)
              // buildFlatbutton(text: "ADD TO CART", context: context)
            ],
          ),
        ));
  }

  Widget buildReviewCard() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 30,
              minRadius: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Sarabonty Alom',
                  style: TextStyle(
                      color: Kprimary.withOpacity(0.8),
                      fontSize: 18,
                      backgroundColor: black,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      itemSize: 14,
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
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'March 15,2021',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.3),
                          fontSize: 12,
                          backgroundColor: black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 77),
          child: Text(
            'Contrary to popuerature rature from 45 BC, mSydney asdasdsaColdsadege ofrature from 45 BC, mSydney asdasdsaCol',
            style: TextStyle(
                color: Kprimary.withOpacity(0.3),
                fontSize: 14,
                backgroundColor: black,
                fontWeight: FontWeight.w600),
            softWrap: true,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
