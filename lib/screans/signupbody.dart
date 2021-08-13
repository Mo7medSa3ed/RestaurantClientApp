import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/special.dart';
import 'package:resturantapp/screans/home.dart';
import 'package:resturantapp/size_config.dart';

class SignupBody extends StatefulWidget {
  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody>
    with SingleTickerProviderStateMixin {
  bool login = true;
  AnimationController _controller;
  Specials specials;
  String email, password, username;
  bool remember = false;
  final formKey = GlobalKey<FormState>();

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
              Text('Create an account',
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
                    v.isEmpty ? 'please enter your name !' : null,
                hint: 'username',
                icon: Icons.person_outline,
                obsecure: false,
                onchanged: (v) => v.toString().isNotEmpty ? username = v : null,
              ),
              SizedBox(
                height: getProportionateScreenHeight(28),
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
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              custumraisedButton('REGISTER', () async => await signupbutton()),
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
                      if (!(specials.isSignup)) {
                        specials.changeSignup(!(specials.isSignup));
                        _controller.forward();
                      }
                    },
                    child: Text(
                      ' Signin',
                      style: TextStyle(color: red.withOpacity(0.7)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  signupbutton() async {
    if (formKey.currentState.validate()) {
      showDialogWidget(context);
      User u =
          User(email: email, password: password, name: username,);
      final res = await API.signupUser(u);
      print(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
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
        showSnackbarWidget(
          context: context,
          msg:
              'please enter your data correctly or check the internet connection !!',
        );
      }
    }
  }
}
