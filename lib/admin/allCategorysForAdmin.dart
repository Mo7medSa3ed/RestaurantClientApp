import 'dart:convert';
import 'dart:ui';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/admin/allCategorysTable.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/provider/appdata.dart';

class AllCategoriesForAdminScrean extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  String name;
  AppData app;

  @override
  Widget build(BuildContext context) {
    app = Provider.of<AppData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: greyw),
        backgroundColor: Kprimary.withOpacity(0.9),
        title: Text(
          "All Categories",
          style: TextStyle(color: greyw, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
              ),
              onPressed: () async => await showdialogForAdd(context)),
          SizedBox(
            width: 8,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Categorys>>(
            future: API.getAllCategories(),
            builder: (c, s) {
              if (s.hasData) {
                app.initCategoryList(s.data);
                return AllCategoryTable();
              } else {
                return Center(
                  child: SpinKitCircle(
                    color: Kprimary,
                  ),
                );
              }
            }),
      ),
    );
  }

  showdialogForAdd(context, {Categorys val}) {
    return showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text(
                val == null ? "Add Category" : "Update Category",
                style: TextStyle(color: Kprimary),
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: MediaQuery.of(c).size.width * 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        initialValue: val == null ? null : val.name,
                        onSaved: (s) => name = s,
                        validator: (String v) =>
                            v.isEmpty ? 'please enter category name !!' : null,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: InputBorder.none,
                            fillColor: greyw,
                            hintText: 'Enter your category name...',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Kprimary.withOpacity(0.35)),
                            filled: true),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(12),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: white),
                              ),
                              color: red,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(12),
                              onPressed: () async {
                                if (val == null) {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    Navigator.pop(c);
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.loading,
                                      text: "loading please wait....",
                                      barrierDismissible: false,
                                    );
                                    final reqData = {"name": name};
                                    final res = await API.addCategory(reqData);
                                    if (res.statusCode == 200 ||
                                        res.statusCode == 201) {
                                      final body = utf8.decode(res.bodyBytes);
                                      final parsed = json.decode(body);
                                      Categorys d = Categorys.fromJson(parsed);
                                      app = Provider.of<AppData>(context,
                                          listen: false);

                                      app.addtoCAtegory(d);
                                      Navigator.of(context).pop();

                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          title: 'Add Category',
                                          text: "Category Added Successfully",
                                          barrierDismissible: false,
                                          confirmBtnColor: Kprimary,
                                          onConfirmBtnTap: () =>
                                              Navigator.of(context).pop());
                                    } else {
                                      Navigator.of(context).pop();
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.loading,
                                          title: 'Error',
                                          text: "some thing went error !!",
                                          barrierDismissible: false,
                                          showCancelBtn: true);
                                    }
                                  }
                                } else {
                                  formKey.currentState.save();
                                  Navigator.pop(c);
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.loading,
                                    text: "loading please wait....",
                                    barrierDismissible: false,
                                  );
                                  final reqData = {
                                    "name": name == null ? val.name : name
                                  };
                                  final res =
                                      await API.updateCategory(reqData, val.id);
                                  if (res.statusCode == 200 ||
                                      res.statusCode == 201) {
                                    final body = utf8.decode(res.bodyBytes);
                                    final parsed = json.decode(body);
                                    Categorys d = Categorys.fromJson(parsed);
                                    app = Provider.of<AppData>(context,
                                        listen: false);

                                    app.updateCategory(d);
                                    Navigator.of(context).pop();

                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        title: 'Update Category',
                                        text: "Category Updated Successfully",
                                        barrierDismissible: false,
                                        confirmBtnColor: Kprimary,
                                        onConfirmBtnTap: () =>
                                            Navigator.of(context).pop());
                                  } else {
                                    Navigator.of(context).pop();
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.loading,
                                        title: 'Error',
                                        text: "some thing went error !!",
                                        barrierDismissible: false,
                                        showCancelBtn: true);
                                  }
                                }
                              },
                              child: Text(
                                val == null ? 'Add' : 'Update',
                                style: TextStyle(color: white),
                              ),
                              color: Kprimary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
