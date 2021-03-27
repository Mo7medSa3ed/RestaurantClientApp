import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/admin/allCategorysForAdmin.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/provider/special.dart';

class AllCategoryTable extends StatefulWidget {
  @override
  _AllCategoryTableState createState() => _AllCategoryTableState();
}

class _AllCategoryTableState extends State<AllCategoryTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var uds;
  var _controller = TextEditingController();
  Specials s;
  List<Categorys> categoryList = [];
  AppData app;
  @override
  void initState() {
    super.initState();
    app = Provider.of<AppData>(context, listen: false);

    categoryList = app.categoryList;
    uds = UDS(
        context: context,
        categoryList: categoryList,
        filtercategoryList: categoryList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app = Provider.of<AppData>(context, listen: true);
    categoryList = app.categoryList;
    uds = UDS(
        context: context,
        categoryList: categoryList,
        filtercategoryList: categoryList);
  }

  void _sort<T>(
    Comparable<T> Function(Categorys d) getField,
    int columnIndex,
    bool ascending,
  ) {
    uds._sort<T>(getField, ascending);
    setState(() {
      // [RestorableBool]'s value cannot be null, so -1 is used as a placeholder
      // to represent `null` in [DataTable]s.
      if (columnIndex == null) {
        _sortColumnIndex = -1;
      } else {
        _sortColumnIndex = columnIndex;
      }
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 16, top: 8),
        child: PaginatedDataTable(
          rowsPerPage: _rowsPerPage,
          onRowsPerPageChanged: (value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          header: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: greyw, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: buildTextField(),
            ),
          ),
          sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
          sortAscending: _sortAscending,
          showCheckboxColumn: false,
          source: uds,
          columns: [
            DataColumn(
              label: Text('Category Name'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.name, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('N.O.Dishes'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.numOfDishes, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Date'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.updatedAt, columnIndex, ascending),
            ),
            DataColumn(
              label: Expanded(child: Center(child: Text('Update / Delete'))),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField() {
    s = Provider.of<Specials>(context, listen: false);
    return Selector<Specials, bool>(
        selector: (_, m) => m.istextempty,
        builder: (_, data, c) {
          return TextField(
            controller: _controller,
            onChanged: (v) {
              if (v.toString().trim() == "") {
                uds.filter("-1");
                s.changeIsEmpty(true);
                _controller.clear();
              } else {
                uds.filter(v.trim());
                s.changeIsEmpty(false);
              }
            },
            cursorColor: Kprimary,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: _controller.text.toString().trim() == ""
                    ? Icon(Icons.search)
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          uds.filter("-1");
                          s.changeIsEmpty(true);
                        }),
                hintText: 'Search with Category name....',
                border: InputBorder.none),
          );
        });
  }
}

class UDS extends DataTableSource {
  List<Categorys> categoryList;
  List<Categorys> filtercategoryList;
  BuildContext context;
  int _selectedCount = 0;
  UDS({this.categoryList, this.context, this.filtercategoryList});

  @override
  DataRow getRow(int index) {
    final Categorys = categoryList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(Categorys.name)),
        DataCell(Center(child: Text(Categorys.numOfDishes.toString()))),
        DataCell(Text(Categorys.updatedAt == null
            ? ''
            : Categorys.updatedAt.substring(0, 10))),
        DataCell(Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: black,
                ),
                onPressed: () => AllCategoriesForAdminScrean()
                    .showdialogForAdd(context, val: Categorys)),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () => delete(Categorys))
          ],
        )))
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => categoryList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Categorys d) getField, bool ascending) {
    categoryList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  filter(value) {
    if (value == "-1") {
      categoryList = filtercategoryList;
      notifyListeners();
      return false;
    }
    final l =
        categoryList.where((element) => element.name.contains(value)).toList();
    categoryList = l;
    notifyListeners();
    return true;
  }

  delete(Categorys c) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: 'Delete Category',
      text: "Are you sure ?",
      barrierDismissible: false,
      confirmBtnColor: red,
      showCancelBtn: true,
      onConfirmBtnTap: () async {
        Navigator.of(context).pop();
        CoolAlert.show(
          context: context,
          type: CoolAlertType.loading,
          text: "loading please wait....",
          barrierDismissible: false,
        );
        final res = await API.deleteCategory(c.name);
        if (res.statusCode == 200 || res.statusCode == 201) {
          Navigator.of(context).pop();
          categoryList.remove(c);
          appData.dishesList.remove(c);
          appData.notifyListeners();
          notifyListeners();
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              animType: CoolAlertAnimType.slideInUp,
              title: 'Delete Category',
              text: "Category Deleted Successfully",
              barrierDismissible: false,
              confirmBtnColor: Kprimary,
              onConfirmBtnTap: () => Navigator.of(context).pop());
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
      },
    );
  }
}
