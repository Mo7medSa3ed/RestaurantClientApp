import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/screans/checkout.dart';
import 'package:resturantapp/size_config.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class CartScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<AppData>(
      builder: (ctx, v, c) => v.cartList.length > 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'My Cart Items',
                    style: TextStyle(
                        color: Kprimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                FadeIn(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeIn,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                          primary: true,
                          shrinkWrap: true,
                          itemCount: v.cartList.length,
                          itemBuilder: (c, i) =>
                              buildCardForCart(c, d: v.cartList[i])),
                    ),
                  ),
                ),
                buildFlatbutton(
                    text: "PROCEED TO CHECKOUT",
                    context: context,
                    onpressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CheckoutScrean())))
              ],
            )
          : Center(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/Cart.png",
                    fit: BoxFit.fill,
                  )),
            ),
    );
  }
}
