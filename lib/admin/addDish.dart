import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/admin/allCategorysForAdmin.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/size_config.dart';
import 'dart:io';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class AddDishScrean extends StatefulWidget {
  @override
  _AddDishScreanState createState() => _AddDishScreanState();
}

class _AddDishScreanState extends State<AddDishScrean> {
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
          "Add Dishes",
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
                  image != null
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16)),
                              child: Image.file(File(image.path),
                                  fit: BoxFit.cover)))
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                            child: Image.asset(
                              "assets/images/splashscrean.png",
                              fit: BoxFit.cover,
                            ),
                          )),
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
                      onPressed: () => showdialog(''),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          CustumTextField(
                            validator: (String v) => v.isEmpty
                                ? 'Please enter your dish name !!'
                                : null,
                            hint: 'Name',
                            value: null,
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
                            value: null,
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
                            value: null,
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
                            value: null,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 24),
                                  decoration: BoxDecoration(
                                      color: grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Consumer<AppData>(
                                    builder: (c, v, ch) =>
                                        SimpleAutocompleteFormField<String>(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
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
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              color: Kprimary.withOpacity(0.6),
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      onSearch: (String search) async =>
                                          search.isEmpty
                                              ? v.categoryList
                                                  .map((e) => e.name)
                                                  .toList()
                                              : v.categoryList
                                                  .map((e) => e.name)
                                                  .toList()
                                                  .where((element) => element
                                                      .trim()
                                                      .toLowerCase()
                                                      .contains(search
                                                          .toLowerCase()
                                                          .trim()))
                                                  .toList(),
                                      onChanged: (value) => setState(
                                          () => selectedCategory = value),
                                      onSaved: (value) => setState(
                                          () => selectedCategory = value),
                                      validator: (letter) => letter == null
                                          ? 'pleasa choose or add category !!'
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.add_box,
                                      color: Kprimary.withOpacity(0.9),
                                      size: 45,
                                    ),
                                    onPressed: () =>
                                        AllCategoriesForAdminScrean()
                                            .showdialogForAdd(
                                          context,
                                        )),
                              ),
                            ],
                          ),
                        ])))
          ],
        )),
        buildFlatbutton(
            text: 'ADD DISH',
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
    if (image == null) {
      return showSnackbarWidget(
          context: context, msg: 'Please choose image !!');
    }

    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      CoolAlert.show(
        context: context,
        animType: CoolAlertAnimType.slideInUp,
        type: CoolAlertType.loading,
        text: "loading please wait....",
        barrierDismissible: false,
      );
      String name2 = image.path.split('/').last;
      FormData form = FormData.fromMap({
        'img': await MultipartFile.fromFile(image.path, filename: name2),
        'numOfPieces': numOfPieces,
        'name': name,
        "desc": desc,
        "price": price,
        'category': app.categoryList
            .firstWhere((e) =>
                e.name.trim().toLowerCase() ==
                selectedCategory.trim().toLowerCase())
            .id
      });

      Dio dio = new Dio();
      final res = await dio
          .post('https://resturant-app12.herokuapp.com/dishes/', data: form);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final newDish = Dish.fromJson(res.data);
        newDish.category = selectedCategory;
        app.addDish(newDish);

        reset();
        Navigator.of(context).pop();
        FocusScope.of(context).requestFocus(FocusNode());
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            animType: CoolAlertAnimType.slideInUp,
            title: 'Add Dish',
            text: "Dish Added Successfully",
            barrierDismissible: false,
            confirmBtnColor: Kprimary,
            onConfirmBtnTap: () => Navigator.of(context).pop());
        setState(() {});
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

  reset() {
    image = null;
    name = null;
    desc = null;
    numOfPieces = null;
    price = null;
    selectedCategory = null;
  }
}
