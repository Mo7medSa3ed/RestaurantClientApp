import 'package:flutter/material.dart';
import 'package:resturantapp/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resturantapp/screans/loginScrean.dart';

class PageViewScrean extends StatefulWidget {
  @override
  _PageViewScreanState createState() => _PageViewScreanState();
}

class _PageViewScreanState extends State<PageViewScrean> {
  int index = 0;
  var controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
            controller: controller,
            onPageChanged: (i) {
              setState(() {
                index = i;
              });
            },
            itemCount: 3,
            itemBuilder: (c, i) => buildpvBody(i),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            left: 50,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => LoginScrean())),
                    child: Text(
                      'SKIP',
                      style: TextStyle(
                          color: grey.withOpacity(0.85),
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  buildCircle(),
                  GestureDetector(
                    onTap: () {
                      if (index < 2 && index > -1) {
                        setState(() {
                          print("sdas");
                          index++;
                          controller.jumpToPage(index);
                        });
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => LoginScrean()));
                      }
                    },
                    child: Text(
                      'NEXT',
                      style: TextStyle(
                          color: red,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget buildpvBody(int i) {
    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    PVData.pvdataList[i].title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 21, color: Kprimary.withOpacity(0.7)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    PVData.pvdataList[i].subtitle,
                    style: TextStyle(
                        fontSize: 36,
                        color: Kprimary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
                width: double.infinity,
                height: 300,
                alignment: Alignment.center,
                child: SvgPicture.asset(PVData.pvdataList[i].img)),
          ),
          Spacer(),
          Expanded(
            flex: 1,
            child: Text(
              PVData.pvdataList[i].description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: grey.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic buildCircle() {
    return Row(
      children: PVData.pvdataList
          .map((e) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: index == e.indx ? red : red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
              ))
          .toList(),
    );
  }
}

class PVData {
  final indx;
  final title;
  final subtitle;
  final description;
  final img;
  PVData({this.title, this.subtitle, this.description, this.img, this.indx});
  static List<PVData> pvdataList = [
    PVData(
        indx: 0,
        title: 'Create an account',
        subtitle: 'Fresh Food',
        img: 'assets/images/eating.svg',
        description:
            'In Particular, the garbled words of \nbear an unmistakable'),
    PVData(
        indx: 1,
        title: 'Log in to your account',
        subtitle: 'Fast Delivery',
        img: 'assets/images/delivary.svg',
        description:
            'In Particular, the garbled words of \nbear an unmistakable'),
    PVData(
        indx: 2,
        title: 'Enjoy our service',
        subtitle: 'Easy Payment',
        img: 'assets/images/payment.svg',
        description:
            'In Particular, the garbled words of \nbear an unmistakable')
  ];
}
