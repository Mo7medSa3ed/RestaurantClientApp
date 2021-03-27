import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/API.dart';
import 'package:resturantapp/admin/updateDish.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/custum_widget.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/provider/special.dart';

class AllDishesTable extends StatefulWidget {
  @override
  _AllDishesTableState createState() => _AllDishesTableState();
}

class _AllDishesTableState extends State<AllDishesTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var uds;
  var _controller = TextEditingController();
  Specials s;
  AppData appData;
  List<Dish> dishList = [];

  @override
  void initState() {
    super.initState();
    appData = Provider.of<AppData>(context, listen: false);
    dishList = appData.dishesList;
    uds = UDS(context: context, dishList: dishList, filterdishList: dishList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appData = Provider.of<AppData>(context, listen: true);
    dishList = appData.dishesList;
    uds = UDS(context: context, dishList: dishList, filterdishList: dishList);
  }

  void _sort<T>(
    Comparable<T> Function(Dish d) getField,
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
      child: Expanded(
        child: Container(
          width: double.infinity,
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
                label: Text('Name'),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.name, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('Category'),
                onSort: (columnIndex, ascending) =>
                    _sort<String>((d) => d.category, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('Price'),
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.price, columnIndex, ascending),
              ),
              DataColumn(
                label: Text('Rate'),
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.rating, columnIndex, ascending),
              ),
              DataColumn(
                // numeric:true
                label: Text('N.O.Pieces'),
                onSort: (columnIndex, ascending) =>
                    _sort<num>((d) => d.numOfPieces, columnIndex, ascending),
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
                hintText: 'Search with dish name....',
                border: InputBorder.none),
          );
        });
  }
}

class UDS extends DataTableSource {
  List<Dish> dishList;
  List<Dish> filterdishList;
  BuildContext context;
  int _selectedCount = 0;

  UDS({this.dishList, this.context, this.filterdishList});

  @override
  DataRow getRow(int index) {
    final dish = dishList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(dish.name != null ? dish.name : "")),
        DataCell(Text(dish.category != null ? dish.category : "")),
        DataCell(Text(dish.price.toString().isNotEmpty
            ? "\$ " + dish.price.toString()
            : "")),
        DataCell(Text(
            dish.rating.toString().isNotEmpty ? dish.rating.toString() : "")),
        DataCell(Center(
            child: Text(dish.numOfPieces.toString().isNotEmpty
                ? dish.numOfPieces.toString()
                : ""))),
        DataCell(Text(
            dish.updatedAt != null ? dish.updatedAt.substring(0, 10) : "")),
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
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => UpdateDish(dish)))),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () async => await deletDish(dish))
          ],
        ))),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => dishList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Dish d) getField, bool ascending) {
    dishList.sort((a, b) {
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
      dishList = filterdishList;
      notifyListeners();
      return false;
    }
    final l =
        dishList.where((element) => element.name.contains(value)).toList();
    dishList = l;
    notifyListeners();
    return true;
  }

  deletDish(Dish dish) async {
    AppData appData = Provider.of<AppData>(context, listen: false);
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        title: 'Delete Dish',
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
              barrierDismissible: false);
        });

    final res = await API.deleteDish(dish.id);
    if (res.statusCode == 200 || res.statusCode == 201) {
      Navigator.of(context).pop();
      dishList.remove(dish);
      appData.dishesList.remove(dish);
      appData.notifyListeners();
      notifyListeners();
      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          animType: CoolAlertAnimType.slideInUp,
          title: 'Delete Dish',
          text: "Dish Deleted Successfully",
          barrierDismissible: false,
          confirmBtnColor: Kprimary,
          onConfirmBtnTap: () => Navigator.of(context).pop());
    } else {
      Navigator.of(context).pop();
      showSnackbarWidget(context: context, msg: 'Some thing went error !!');
    }
  }
}
