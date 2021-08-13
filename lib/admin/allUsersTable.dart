import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/models/user.dart';

import 'package:resturantapp/provider/special.dart';

class AllUsersTable extends StatefulWidget {
  final List<User> userlist;
  AllUsersTable({this.userlist});
  @override
  _AllUsersTableState createState() => _AllUsersTableState();
}

class _AllUsersTableState extends State<AllUsersTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var uds;
  var _controller = TextEditingController();
  Specials s;
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    userList = widget.userlist;
    uds = UDS(context: context, userList: userList, filterUserList: userList);
  }

  void _sort<T>(
    Comparable<T> Function(User d) getField,
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
              label: Text('UserName'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.name, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Email'),
            ),
            DataColumn(
              label: Text('Phone'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.phone, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Gender'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.gender, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('Date'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.updatedAt, columnIndex, ascending),
            ),
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
                hintText: 'Search with username....',
                border: InputBorder.none),
          );
        });
  }
}

class UDS extends DataTableSource {
  List<User> userList;
  List<User> filterUserList;
  BuildContext context;
  int _selectedCount = 0;
  UDS({this.userList, this.context, this.filterUserList});

  @override
  DataRow getRow(int index) {
    final user = userList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(user.name)),
        DataCell(Text(user.email)),
        DataCell(Text(user.phone != null ? user.phone : "-----")),
        DataCell(Text(user.gender != null ? user.gender : "-----")),
        DataCell(Text(
            user.updatedAt == null ? '' : user.updatedAt.substring(0, 10))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userList.length;

  @override
  int get selectedRowCount => _selectedCount;

  // void _sort<T>(Comparable<T> Function(User d) getField, bool ascending) {
  //   userList.sort((a, b) {
  //     final aValue = getField(a);
  //     final bValue = getField(b);
  //     return ascending
  //         ? Comparable.compare(aValue, bValue)
  //         : Comparable.compare(bValue, aValue);
  //   });
  //   notifyListeners();
  // }

  filter(value) {
    if (value == "-1") {
      userList = filterUserList;
      notifyListeners();
      return false;
    }
    final l =
        userList.where((element) => element.name.contains(value)).toList();
    userList = l;
    notifyListeners();
    return true;
  }
}
