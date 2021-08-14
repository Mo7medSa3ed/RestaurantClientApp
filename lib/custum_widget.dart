import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustumTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obsecure;
  final Function onchanged;
  final Function onsaved;
  final Function validator;
  final String value;
  final int v;

  CustumTextField(
      {this.hint,
      this.icon,
      this.obsecure,
      this.onchanged,
      this.validator,
      this.onsaved,
      this.v,
      this.value});

  @override
  _CustumTextFieldState createState() => _CustumTextFieldState();
}

class _CustumTextFieldState extends State<CustumTextField> {
  bool shadow = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: white,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0),
                  )
                ]
              : null,
          borderRadius: BorderRadius.circular(8),
          color: grey.withOpacity(0.05)),
      child: Focus(
        onFocusChange: (f) {
          setState(() {
            shadow = f;
          });
        },
        child: TextFormField(
          // style: TextStyle(color: Kprimary),
          validator: widget.validator,
          onChanged: widget.onchanged,
          onSaved: widget.onsaved,
          initialValue: widget.value,
          maxLines: widget.v == 0 ? 5 : 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w500, letterSpacing: 1, fontSize: 14),
              prefixIcon: Icon(
                widget.icon,
                size: 25,
              )),
          obscureText: widget.obsecure,
          inputFormatters:
              widget.v == 1 ? [FilteringTextInputFormatter.digitsOnly] : null,
          keyboardType: widget.hint.toLowerCase() == 'email'
              ? TextInputType.emailAddress
              : widget.hint.toLowerCase() == 'phone'
                  ? TextInputType.phone
                  : widget.v == 1
                      ? TextInputType.number
                      : TextInputType.text,
        ),
      ),
    );
  }
}

custumraisedButton(text, pressed) {
  return ElevatedButton(
    onPressed: pressed,
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

buildFlatbutton({text, onpressed, id, context}) {
  AppData appdata = Provider.of<AppData>(context, listen: true);
  bool disable = appdata.cartList.map((e) => e.id).toList().contains(id);
  return Container(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(disable ? grey : red),
            padding: MaterialStateProperty.all(EdgeInsets.all(20))),
        onPressed: disable ? null : onpressed,
        child: Text(
          appdata.cartList.map((e) => e.id).toList().contains(id)
              ? 'Added To Cart !!'
              : text,
          style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
        ),
      ));
}

noNetworkwidget() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: grey[300].withOpacity(0.67),
    child: Image.asset('assets/images/net.png'),
  );
}

Widget buildCardForCart(context, {Dish d, bool t = false}) {
  AppData appdata = Provider.of<AppData>(context, listen: false);
  int amount = d.amount;
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
                      d.img == null ? null : d.img.replaceAll('http', 'https')),
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
              d.name,
              style: TextStyle(
                  color: Kprimary, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar.builder(
                  onRatingUpdate: (v) {},
                  itemSize: 14,
                  initialRating: d.rating.toDouble(),
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
                  '(${t == true ? d.review.length : d.reviews.length} review)',
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
                  '${d.numOfPieces} Pieces',
                  style: TextStyle(
                      color: Kprimary.withOpacity(0.35),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  '\$ ${d.price}',
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
                    onTap: t
                        ? null
                        : () {
                            if (amount > 1) {
                              amount--;
                              appdata.changeAmount(d, amount);
                            }
                          },
                    child: Icon(
                      Icons.indeterminate_check_box_outlined,
                      color: amount > 1 ? Kprimary : Kprimary.withOpacity(0.35),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('$amount'),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: t
                          ? null
                          : () {
                              amount++;
                              appdata.changeAmount(d, amount);
                            },
                      child: Icon(
                        Icons.add_box_outlined,
                        color: Kprimary,
                      )),
                  Spacer(),
                  GestureDetector(
                      onTap: t
                          ? null
                          : () {
                              addtoFav(context, d.id);
                            },
                      child: Icon(
                        appdata.loginUser.fav.contains(d.id)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: appdata.loginUser.fav.contains(d.id)
                            ? red
                            : Kprimary.withOpacity(0.35),
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                      onTap: t
                          ? null
                          : () {
                              appdata.removeFromCart(d);
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  animType: CoolAlertAnimType.slideInUp,
                                  title: 'Delete Dish From Cart',
                                  text: "Deleted Successfully",
                                  barrierDismissible: false,
                                  confirmBtnColor: Kprimary,
                                  onConfirmBtnTap: () =>
                                      Navigator.of(context).pop());
                            },
                      child: Icon(
                        Icons.delete_outline,
                        color: Kprimary,
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

buildCardForDishes(
    width, double c, context, img, m, height, Dish d, isLiked, ontap,
    {test = false}) {
  final hei = MediaQuery.of(context).size.height;
  final wid = MediaQuery.of(context).size.width;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.only(right: m),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(c),
        ),
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(c),
                  child: Image.network(
                    img != null ? img.replaceAll('http', 'https') : img,
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
                          padding:
                              const EdgeInsets.only(left: 2, right: 0, top: 2.5),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
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
        d.name,
        style: TextStyle(
            color: Kprimary, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      SizedBox(
        height: 2,
      ),
      RatingBar.builder(
        onRatingUpdate: (v) {},
        itemSize: 16,
        initialRating: d.rating.toDouble(),
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
          Text(
            d.category,
            style: TextStyle(
                color: Kprimary.withOpacity(0.35),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          ),
          test
              ? Text(
                  '\$ ${d.price}',
                  style: TextStyle(
                      color: red, fontSize: 14, fontWeight: FontWeight.w600),
                )
              : Container(),
        ],
      ),
    ],
  );
}

showDialogWidget(context) {
  CoolAlert.show(
    context: context,
    animType: CoolAlertAnimType.slideInUp,
    type: CoolAlertType.loading,
    text: "loading please wait....",
    barrierDismissible: false,
  );
}

saveUserToshared(user, context) async {
  final prfs = await SharedPreferences.getInstance();
  prfs.setString('user', user);
}

saveUsertoAppdata(user, context) {
  AppData appdata = Provider.of<AppData>(context, listen: false);
  final parsed = json.decode(user);
  User u = User.fromJson(parsed);
  appdata.initLoginUser(u);
}

showSnackbarWidget({msg, context, icon}) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    animType: CoolAlertAnimType.scale,
    confirmBtnColor: red,
    title: 'Error',
    text: "some thing went error !!",
    barrierDismissible: false,
  );
}

cCardForDishes(width, double c, context, m, height) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.only(right: m),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(c),
          color: black,
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        'Thai beef fried rice',
        style: TextStyle(
            color: Kprimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            backgroundColor: black),
      ),
      SizedBox(
        height: 10,
      ),
      RatingBar.builder(
        onRatingUpdate: (v) {},
        itemSize: 16,
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
      ),
    ],
  );
}

Future<bool> addtoFav(context, dishid) async {
  AppData appdata = Provider.of<AppData>(context, listen: false);
  API.addanddelteFav(appdata.loginUser.id, dishid);
  if (appdata.loginUser.fav.contains(dishid)) {
    appdata.removeFromFavWithId(dishid);
    return false;
  } else {
    appdata.addToFav(dishid);
    return true;
  }
  //if (res.statusCode == 200 || res.statusCode == 201) {
  //}
}

buildListTile(Dish d, context) {
  return GestureDetector(
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DetailsScrean(
              d.id,
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
                      NetworkImage(d.img.replaceAll('http', 'https')),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      d.name,
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
                          onRatingUpdate: (v) {},
                          itemSize: 14,
                          initialRating: d.rating.toDouble(),
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
                          ('(${d.numOfPieces} pieces)'),
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
                  ('\$ ${d.price}\t'),
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
