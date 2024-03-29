import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_dish_card.dart';
import 'package:resturantapp/components/primary_flatButton.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widgets.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/review.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/detailsloading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class DetailsScrean extends StatefulWidget {
  final String id;
  DetailsScrean(this.id);
  @override
  _DetailsScreanState createState() => _DetailsScreanState();
}

class _DetailsScreanState extends State<DetailsScrean> {
  AppData appdata;
  Dish dish;
  double rating = 1.0;
  String msg;
  Review rev;
  bool test = true;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var controller = TextEditingController();
  FocusNode _focus = new FocusNode();
  bool networktest = true;
  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      networktest = false;
    } else {
      networktest = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkNetwork();
    getData();
  }

  getData() async {
    appdata = Provider.of<AppData>(context, listen: false);

    await API.getOneDish(widget.id).then((value) {
      if (value['status']) dish = value['data'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: networktest
          ? SafeArea(
              child: dish != null
                  ? FadeIn(
                      child: body(),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    )
                  : DetailsLoading())
          : noNetworkwidget(),
    );
  }

  Widget body() {
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: RefreshIndicator(
              onRefresh: () => getData(),
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  PrimaryDishCard(
                    radius: 25.0,
                    rightMargin: 0.0,
                    enableTap: false,
                    dish: dish,
                    width: wid,
                    height: hei > wid ? hei * 0.24 : hei * 0.4,
                    isLiked: appdata.loginUser.fav.contains(dish.id),
                    ontap: (b) async => await addtoFav(context, dish.id),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        '${dish.numOfPieces} Pieces',
                        style: TextStyle(
                            color: Kprimary.withOpacity(0.3),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        '\$ ${dish.price}',
                        style: TextStyle(
                            color: red,
                            fontSize: 16,
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
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dish.desc,
                    style: TextStyle(
                        color: Kprimary.withOpacity(0.3),
                        fontSize: 14,
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
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                      children: dish.reviews.length > 0
                          ? dish.reviews
                              .map(
                                (e) => buildReviewCard(e),
                              )
                              .toList()
                          : [
                              Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(
                                    child: Text('No reviews yet.',
                                        style: TextStyle(
                                            color: Kprimary.withOpacity(0.3),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ))
                            ]),
                  Form(
                    key: formKey,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 12, right: 12, top: 12, bottom: 0),
                      child: TextFormField(
                        focusNode: _focus,
                        controller: controller,
                        onSaved: (String s) => msg = s,
                        validator: (String s) =>
                            s.isEmpty ? 'Please enter your message!!' : null,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        maxLength: 300,
                        maxLines: 3,
                        decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: red),
                                borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: red),
                                borderRadius: BorderRadius.circular(20)),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          itemSize: 24,
                          initialRating: rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber[800],
                          ),
                          onRatingUpdate: (rate) {
                            setState(() {
                              rating = rate;
                            });
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
                            onPressed: () async =>
                                test ? await addreview() : await updatereview())
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
        ),
        PrimaryFlatButton(
            text: "ADD TO CART",
            id: dish.id,
            onPressed: () {
              appdata.addtoCart(dish);
            })
      ],
    );
  }

  updatereview() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      showDialogWidget(context);
      Review r = Review(user: rev.user, rate: rating, msg: msg);

      final res = (await API.updateReview(r, dish.id, rev.id));
      if (res.statusCode == 200 || res.statusCode == 201) {
        rev.msg = msg;
        rev.rate = rating;
        dish.rating = rating;
        appdata.changeRateForHome(id: dish.id, rate: rating);
        controller.clear();
        rating = 1.0;
        test = true;
        rev = null;
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            animType: CoolAlertAnimType.scale,
            title: 'Update Review',
            text: "Review Updated Successfully",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
      } else {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
        showSnackbarWidget(context: context, msg: 'Some thing went wrong !!');
      }
      setState(() {});
    }
  }

  addreview() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      showDialogWidget(context);
      User u = appdata.loginUser;
      Review rev = Review(
          user: User(id: u.id, name: u.name, img: u.avatar),
          rate: rating,
          msg: msg);

      final res = (await API.addReview(rev, dish.id));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = utf8.decode(res.bodyBytes);
        final parsed = json.decode(body);
        parsed['category'] = dish.category;
        dish = Dish.fromOneJson(parsed);
        appdata.changeRateForHome(id: dish.id, rate: dish.rating);

        controller.clear();
        rating = 1.0;
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            animType: CoolAlertAnimType.scale,
            title: 'Add Review',
            text: "Review Added Successfully",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
      } else {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
        showSnackbarWidget(context: context, msg: 'Some thing went wrong !!');
      }
      setState(() {});
    }
  }

  deletereview(Review rev) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: 'Delete Review',
        text: "Are you sure ?",
        barrierDismissible: false,
        confirmBtnColor: red,
        showCancelBtn: true,
        onConfirmBtnTap: () async {
          Navigator.of(context).pop();
          CoolAlert.show(
              animType: CoolAlertAnimType.scale,
              context: context,
              type: CoolAlertType.loading,
              text: "loading please wait....",
              barrierDismissible: false);
          final res = (await API.deleteReview(dish.id, rev.id));
          if (res.statusCode == 200 || res.statusCode == 201) {
            final body = utf8.decode(res.bodyBytes);
            final parsed = json.decode(body);
            parsed['category'] = dish.category;
            dish = Dish.fromOneJson(parsed);
            appdata.changeRateForHome(id: dish.id, rate: dish.rating);
            Navigator.pop(context);
            FocusScope.of(context).requestFocus(FocusNode());
            CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                animType: CoolAlertAnimType.scale,
                title: 'Delete Review',
                text: "Review Deleted Successfully",
                barrierDismissible: false,
                confirmBtnColor: Kprimary,
                onConfirmBtnTap: () => Navigator.of(context).pop());
          } else {
            Navigator.pop(context);
            FocusScope.of(context).requestFocus(FocusNode());
            showSnackbarWidget(
                context: context, msg: 'Some thing went wrong !!');
          }
          setState(() {});
        });
  }

  Widget buildReviewCard(Review e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 27,
              minRadius: 27,
              backgroundColor: Kprimary.withOpacity(0.9),
              backgroundImage:
                  e.user.img != null ? NetworkImage(e.user.img) : null,
              child: e.user.img == null
                  ? Icon(
                      Icons.person,
                      size: 30,
                      color: white,
                    )
                  : null,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  e.user.name,
                  style: TextStyle(
                      color: Kprimary.withOpacity(0.8),
                      fontSize: 18,
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
                      onRatingUpdate: null,
                      updateOnDrag: false,
                      ignoreGestures: true,
                      itemSize: 14,
                      initialRating: e.rate.toDouble(),
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
                      DateFormat.yMMMEd('en_US')
                          .format(DateTime.parse(e.updatedAt)),
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
            appdata.loginUser.id == e.user.id
                ? Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Kprimary,
                          ),
                          onPressed: () {
                            controller.text = e.msg;
                            rating = e.rate.toDouble();
                            FocusScope.of(context).requestFocus(_focus);

                            test = false;
                            rev = e;
                            setState(() {});
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: red,
                          ),
                          onPressed: () async => await deletereview(e))
                    ],
                  )
                : Container()
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 77),
          child: Text(
            e.msg,
            style: TextStyle(
                color: Kprimary.withOpacity(0.3),
                fontSize: 14,
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
