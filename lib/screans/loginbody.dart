import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primart_elevatedButtom.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/special.dart';
import 'package:resturantapp/screans/home.dart';
import 'package:resturantapp/size_config.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody>
    with SingleTickerProviderStateMixin {
  bool login = true;
  bool remember = false;
  final formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Specials specials;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _controller.forward();
    specials = Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String email, password;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FadeTransition(
        opacity: Tween<double>(begin: 0.2, end: 1.0).animate(_controller),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(65),
              ),
              Text('Log in to your account',
                  style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 22,
                      color: Kprimary,
                      fontWeight: FontWeight.w600)),
              SizedBox(
                height: getProportionateScreenHeight(65),
              ),
              CustumTextField(
                validator: (String v) =>
                    v.isEmpty ? 'please enter your email !' : null,
                hint: 'email',
                icon: Icons.email_outlined,
                obsecure: false,
                onchanged: (v) => v.toString().isNotEmpty ? email = v : null,
              ),
              SizedBox(
                height: getProportionateScreenHeight(28),
              ),
              CustumTextField(
                validator: (String v) =>
                    v.isEmpty ? 'please enter your password !' : null,
                hint: 'password',
                icon: Icons.lock_outlined,
                obsecure: true,
                onchanged: (v) => v.toString().isNotEmpty ? password = v : null,
              ),
              SizedBox(
                height: getProportionateScreenHeight(16),
              ),
              Row(
                children: [
                  Checkbox(
                      value: remember,
                      onChanged: (v) {
                        setState(() {
                          remember = v;
                        });
                      }),
                  Text('Remember me',
                      style: TextStyle(letterSpacing: 1, fontSize: 14)),
                  /*  Spacer(),
                  InkWell(
                    child: Text(
                      'Forget password?',
                      style: TextStyle(color: red.withOpacity(0.7)),
                    ),
                  ) */
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              PrimaryElevatedButton(
                  text: 'LOGIN', onpressed: () async => await loginButton()),
              SizedBox(
                height: getProportionateScreenHeight(23),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New user?',
                      style: TextStyle(
                          color: Kprimary.withOpacity(0.7), fontSize: 16)),
                  InkWell(
                    onTap: () {
                      if (specials.isSignup) {
                        specials.changeSignup(!(specials.isSignup));
                        _controller.forward();
                      }
                    },
                    child: Text(
                      ' Signup',
                      style: TextStyle(color: red.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  loginButton() async {
    if (formKey.currentState.validate()) {
      showDialogWidget(context);
      User u = User(email: email, password: password);
      final res = (await API.loginUser(u));
     
      if (res.statusCode == 200) {
        final u = utf8.decode(res.bodyBytes);
        if (remember) {
          saveUserToshared(u, context);
          saveUsertoAppdata(u, context);
        } else {
          saveUsertoAppdata(u, context);
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Home()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(FocusNode());
        showSnackbarWidget(
          context: context,
          msg:
              'please enter your data correctly or check the internet connection!!',
        );
      }
    }
  }
}
