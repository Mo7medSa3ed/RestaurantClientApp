import 'dart:convert';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/components/primary_flatButton.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widgets.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool isMale;
  DateTime selectedDate;
  bool shadow = false;
  File image;
  TextEditingController controller = TextEditingController(text: '');
  String name, phone, address, location, email;
  final formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1880),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        shadow = false;
      });
    }
  }

  Future getImage(source, id) async {
    // ignore: deprecated_member_use
    await ImagePicker.pickImage(source: source).then((value) async {
      if (value != null) {
        await API.updateImage(value, id);
        setState(() {
          image = value;
        });
        return;
      }
    }).catchError((e) => print(e));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<AppData>(
      builder: (ctx, v, c) => SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, bottom: 20, top: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width:
                                  height > width ? width * 0.45 : height * 0.45,
                              height:
                                  height > width ? width * 0.43 : height * 0.43,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Kprimary.withOpacity(0.4),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(1, 10),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(200),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          v.loginUser.avatar == null
                                              ? img
                                              : v.loginUser.avatar),
                                      fit: BoxFit.fill)),
                              child: Stack(
                                alignment: Alignment(0.9, 0.7),
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 60,
                                      color: Kprimary.withOpacity(0.9),
                                    ),
                                    onPressed: () => showdialog(v.loginUser.id),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),
                            CustumTextField(
                              validator: (String v) => v.isEmpty
                                  ? 'Please enter your name !!'
                                  : null,
                              hint: 'Full Name',
                              value: v.loginUser.name,
                              icon: Icons.person,
                              obsecure: false,
                              onchanged: (v) =>
                                  v.toString().isNotEmpty ? name = v : null,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(16),
                            ),
                            CustumTextField(
                              validator: (String v) => v.isEmpty
                                  ? 'Please enter your email !!'
                                  : null,
                              hint: 'Email',
                              value: v.loginUser.email,
                              icon: Icons.email,
                              obsecure: false,
                              onchanged: (v) =>
                                  v.toString().isNotEmpty ? email = v : null,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(16),
                            ),
                            CustumTextField(
                              /*  validator: (String v) =>
                              v.isEmpty ? 'Please enter your phone !!' : null, */
                              hint: 'Phone',
                              value: v.loginUser.phone,
                              icon: Icons.call,
                              obsecure: false,
                              onchanged: (v) =>
                                  v.toString().isNotEmpty ? phone = v : null,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(16),
                            ),
                            CustumTextField(
                              /*  validator: (String v) =>
                              v.isEmpty ? 'Please enter your address !!' : null, */
                              hint: 'Address',
                              value: v.loginUser.address,
                              icon: Icons.location_city,
                              obsecure: false,
                              onchanged: (v) =>
                                  v.toString().isNotEmpty ? address = v : null,
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(16),
                            ),
                            // CustumTextField(
                            //   /* validator: (String v) =>
                            //   v.isEmpty ? 'Please enter your location !!' : null, */
                            //   hint: 'Location',
                            //   value: v.loginUser.location,
                            //   icon: Icons.person,
                            //   obsecure: false,
                            //   onchanged: (v) =>
                            //       v.toString().isNotEmpty ? location = v : null,
                            // ),
                            // SizedBox(
                            //   height: getProportionateScreenHeight(16),
                            // ),
                            Container(
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
                                child: ListTile(
                                    onTap: () async {
                                      setState(() {
                                        shadow = true;
                                      });
                                      await _selectDate(ctx);
                                    },
                                    leading: Icon(Icons.calendar_today),
                                    title: Text(
                                      v.loginUser.dob != null
                                          ? DateFormat.yMMMMEEEEd('en_US')
                                              .format(DateTime.parse(
                                                  v.loginUser.dob))
                                          : selectedDate != null
                                              ? DateFormat.yMMMMEEEEd('en_US')
                                                  .format(selectedDate)
                                              : 'Date Of Birth',
                                      style: TextStyle(
                                          color: selectedDate != null
                                              ? Kprimary
                                              : Colors.grey),
                                    ),
                                    trailing: selectedDate != null
                                        ? IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              setState(() {
                                                selectedDate = null;
                                              });
                                            })
                                        : null)),
                            SizedBox(
                              height: getProportionateScreenHeight(16),
                            ),
                            RadioListTile(
                              selected: false,
                              value: true,
                              title: Text(
                                'Male',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              groupValue: isMale == null
                                  ? isMale = (v.loginUser.gender == 'Male')
                                      ? true
                                      : null
                                  : isMale, // v.loginUser.gender!=null?v.loginUser.gender:
                              onChanged: (v) {
                                setState(() {
                                  isMale = v;
                                });
                              },
                            ),
                            RadioListTile(
                              selected: false,
                              value: false,
                              title: Text(
                                'Female',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              groupValue: isMale == null
                                  ? isMale = (v.loginUser.gender == 'Female')
                                      ? true
                                      : null
                                  : isMale,
                              onChanged: (v) {
                                setState(() {
                                  isMale = v;
                                });
                              },
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(30),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            PrimaryFlatButton(
                text: 'UPDATE PROFILE',
                onPressed: () async => await updateProfile(ctx, v.loginUser)),
          ],
        ),
      ),
    );
  }

  showdialog(id) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Choose from',
                style: TextStyle(color: Kprimary),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            size: 45,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await getImage(ImageSource.camera, id);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.photo_library_outlined,
                            size: 45,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await getImage(ImageSource.gallery, id);
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(red),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(12))),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'cancel',
                        style: TextStyle(color: white),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  updateProfile(context, User user) async {
    if (formKey.currentState.validate()) {
      showDialogWidget(context);
      User u = User(
          name: name == null ? user.name : name,
          phone: phone == null ? user.phone : phone,
          address: address == null ? user.address : address,
          location: location,
          dob: selectedDate == null ? user.dob : selectedDate.toString(),
          email: email == null ? user.email : email,
          gender: isMale == null
              ? user.gender
              : isMale
                  ? 'Male'
                  : 'Female');

      final res = (await API.updateUser(u, user.id));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final us = utf8.decode(res.bodyBytes);
        saveUsertoAppdata(us, context);
        Navigator.of(context).pop();
        FocusScope.of(context).requestFocus(FocusNode());
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            animType: CoolAlertAnimType.scale,
            title: 'Update Profile',
            text: "Profile Updated Successfully",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
      } else {
        Navigator.of(context).pop();
        FocusScope.of(context).requestFocus(FocusNode());
        showSnackbarWidget(context: context, msg: 'Some thing went error !!');
        setState(() {});
      }
    }
  }
}
