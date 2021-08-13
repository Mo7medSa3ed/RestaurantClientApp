import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class UpdateDish extends StatefulWidget {
  final Dish dish;
  UpdateDish(this.dish);

  @override
  _UpdateDishState createState() => _UpdateDishState();
}

class _UpdateDishState extends State<UpdateDish> {
  bool shadow = false;
  PickedFile image;
  AppData app;
  TextEditingController controller = TextEditingController(text: '');
  String name;
  String desc;
  num price;
  String selectedCategory;
  num numOfPieces;
  final formKey = GlobalKey<FormState>();
  final sKey = GlobalKey<ScaffoldState>();

  Future getImage(source, id) async {
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.pickImage(source: source).then((value) async {
      if (value != null) {
        await API.updateImageForDish(value, id);
        setState(() {
          image = value;
        });
        return;
      }
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    app = Provider.of<AppData>(context, listen: false);
    return Scaffold(
      key: sKey,
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: greyw),
        backgroundColor: Kprimary.withOpacity(0.85),
        title: Text(
          "Update Dishes",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w600),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),

          children: [
            Container(
              width: height > width ? width : height * 0.45,
              height: height > width ? width * 0.45 : height * 0.43,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Kprimary.withOpacity(0.4),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(1, 10),
                  )
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
              ),
              child: Stack(
                alignment: Alignment(0.0, 1.4),
                children: [
                  Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                          child: Image.network(
                              widget.dish.img.replaceAll("http", "https"),
                              fit: BoxFit.cover))),
                  Container(
                    height: 68,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Kprimary.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: greyw2.withOpacity(0.9),
                      ),
                      onPressed: () => showdialog(widget.dish.id),
                    ),
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 20, top: 20),
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          CustumTextField(
                            validator: (String v) => v.isEmpty
                                ? 'Please enter your dish name !!'
                                : null,
                            hint: 'Name',
                            value: widget.dish.name,
                            icon: Icons.food_bank_outlined,
                            obsecure: false,
                            onsaved: (v) =>
                                v.toString().isNotEmpty ? name = v : null,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(16),
                          ),
                          CustumTextField(
                            v: 0,
                            validator: (String v) => v.isEmpty
                                ? 'Please enter your dish description !!'
                                : null,
                            hint: 'Description',
                            value: widget.dish.desc,
                            icon: Icons.food_bank_outlined,
                            obsecure: false,
                            onsaved: (v) =>
                                v.toString().isNotEmpty ? desc = v : null,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(16),
                          ),
                          CustumTextField(
                            v: 1,
                            validator: (String v) => v.isEmpty
                                ? 'Please enter your dish price !!'
                                : null,
                            hint: 'Price',
                            value: widget.dish.price.toString(),
                            icon: Icons.monetization_on_outlined,
                            obsecure: false,
                            onsaved: (v) => v.toString().isNotEmpty
                                ? price = double.parse(v.toString().trim())
                                : null,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(16),
                          ),
                          CustumTextField(
                            v: 1,
                            validator: (String v) => v.isEmpty
                                ? 'Please enter number of pieces !!'
                                : null,
                            hint: 'Number of pieces',
                            value: widget.dish.numOfPieces.toString(),
                            icon: Icons.format_list_numbered_rounded,
                            obsecure: false,
                            onsaved: (v) => v.toString().isNotEmpty
                                ? numOfPieces =
                                    double.parse(v.toString().trim())
                                : null,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(16),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            decoration: BoxDecoration(
                                color: grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8)),
                            child: SimpleAutocompleteFormField<String>(
                              initialValue: widget.dish.category,
                              style: TextStyle(fontWeight: FontWeight.w400),
                              autocorrect: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Choose category",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                    fontSize: 14),
                              ),
                              suggestionsHeight: 200.0,
                              maxSuggestions: 10,
                              itemBuilder: (context, item) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                      color: Kprimary.withOpacity(0.6),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              onSearch: (String search) async => search.isEmpty
                                  ? app.categoryList.map((e) => e.name).toList()
                                  : app.categoryList
                                      .map((e) => e.name)
                                      .toList()
                                      .where((element) => element
                                          .trim()
                                          .toLowerCase()
                                          .contains(
                                              search.toLowerCase().trim()))
                                      .toList(),
                              onChanged: (value) =>
                                  setState(() => selectedCategory = value),
                              onSaved: (value) =>
                                  setState(() => selectedCategory = value),
                            ),
                          ),
                        ])))
          ],
        )),
        buildFlatbutton(
            text: 'UPDATE DISH',
            context: context,
            onpressed: () async => await addDish(context)),
      ],
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

  addDish(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        text: "loading please wait....",
        barrierDismissible: false,
      );
      var cat;
      if (selectedCategory == null) {
        cat = app.categoryList
            .firstWhere((e) =>
                e.name.trim().toLowerCase() ==
                widget.dish.category.trim().toLowerCase())
            .id;
      } else {
        cat = app.categoryList
            .firstWhere((e) =>
                e.name.trim().toLowerCase() ==
                selectedCategory.trim().toLowerCase())
            .id;
      }
      final reqData = {
        "name": name == null ? widget.dish.name : name,
        "desc": desc == null ? widget.dish.desc : desc,
        "price": price == null ? widget.dish.price : price,
        "numOfPieces":
            numOfPieces == null ? widget.dish.numOfPieces : numOfPieces,
        "category": selectedCategory == null ? cat : cat,
      };
      final res = await API.updateDish(widget.dish.id, reqData);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = utf8.decode(res.bodyBytes);
        final parsed = json.decode(body);
        final d = Dish.fromJson(parsed);

        d.category =
            selectedCategory == null ? widget.dish.category : selectedCategory;
        app.updateDish(d);
        Navigator.of(context).pop();
        FocusScope.of(context).requestFocus(FocusNode());
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            animType: CoolAlertAnimType.slideInUp,
            title: 'Update Dish',
            text: "Dish Updated Successfully",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
      } else {
        Navigator.of(context).pop();
        FocusScope.of(context).requestFocus(FocusNode());
        CoolAlert.show(
            context: context,
            type: CoolAlertType.loading,
            animType: CoolAlertAnimType.slideInUp,
            title: 'Error',
            text: "some thing went error !!",
            barrierDismissible: false,
            showCancelBtn: true);
        setState(() {});
      }
    }
  }
}
