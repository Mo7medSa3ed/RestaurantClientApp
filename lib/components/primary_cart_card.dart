import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/appdata.dart';

class PrimaryCartCard extends StatefulWidget {
  final dish;
  final details;
  final test;
  final amount;

  PrimaryCartCard(this.dish,
      {this.test = false, this.amount, this.details = false});

  @override
  _PrimaryCartCardState createState() => _PrimaryCartCardState();
}

class _PrimaryCartCardState extends State<PrimaryCartCard> {
  AppData appdata;
  int amount;
  @override
  void initState() {
    appdata = Provider.of<AppData>(context, listen: false);
    amount = widget.details ? widget.amount : widget.dish.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 102,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        widget.dish.img == null ? null : widget.dish.img),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.dish.name,
                style: TextStyle(
                    color: Kprimary, fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingBar.builder(
                    onRatingUpdate: null,
                    updateOnDrag: false,
                    ignoreGestures: true,
                    itemSize: 14,
                    initialRating: widget.dish.rating.toDouble(),
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
                  Text(
                    '(${widget.dish.reviews.length} review)',
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.dish.numOfPieces} Pieces',
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.35),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    '\$ ${widget.dish.price}',
                    style: TextStyle(
                        color: red, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Container(
                width: (MediaQuery.of(context).size.width) - 188,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.test
                          ? null
                          : widget.details
                              ? () {
                                  if (amount > 1) {
                                    amount--;
                                    appdata.changeAmountForDetails(
                                        amount, widget.dish.id);
                                  }
                                }
                              : () {
                                  if (amount > 1) {
                                    amount--;
                                    appdata.changeAmount(widget.dish, amount);
                                  }
                                },
                      child: Icon(
                        Icons.indeterminate_check_box_outlined,
                        color: widget.test
                            ? Kprimary.withOpacity(0.35)
                            : amount > 1
                                ? Kprimary
                                : Kprimary.withOpacity(0.35),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      '$amount',
                      style: TextStyle(
                          color: widget.test
                              ? Kprimary.withOpacity(0.35)
                              : Kprimary),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: widget.test
                            ? null
                            : widget.details
                                ? () {
                                    amount++;
                                    appdata.changeAmountForDetails(
                                        amount, widget.dish.id);
                                  }
                                : () {
                                    amount++;
                                    appdata.changeAmount(widget.dish, amount);
                                  },
                        child: Icon(
                          Icons.add_box_outlined,
                          color: widget.test
                              ? Kprimary.withOpacity(0.35)
                              : Kprimary,
                        )),
                    Spacer(),
                    GestureDetector(
                        onTap: widget.test
                            ? null
                            : () {
                                addtoFav(context, widget.dish.id);
                              },
                        child: Icon(
                          appdata.loginUser.fav.contains(widget.dish.id)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          color: appdata.loginUser.fav.contains(widget.dish.id)
                              ? red
                              : Kprimary.withOpacity(0.35),
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: widget.test
                            ? null
                            : widget.details
                                ? () {
                                    appdata
                                        .deleteItemForDetails(widget.dish.id);
                                  }
                                : () {
                                    appdata.removeFromCart(widget.dish);
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        animType: CoolAlertAnimType.scale,
                                        title: 'Delete Dish From Cart',
                                        text: "Deleted Successfully",
                                        barrierDismissible: false,
                                        confirmBtnColor: Kprimary,
                                        onConfirmBtnTap: () =>
                                            Navigator.of(context).pop());
                                  },
                        child: Icon(
                          Icons.delete_outline,
                          color: widget.test
                              ? Kprimary.withOpacity(0.35)
                              : Kprimary,
                        )),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
