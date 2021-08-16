import 'package:flutter/foundation.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/order.dart';
import 'package:resturantapp/models/user.dart';
import 'package:resturantapp/models/categorys.dart';

class AppData extends ChangeNotifier {
  User loginUser;
  List<Dish> dishesList = [];
  List<Dish> loadeddishesList = [];
  List<Categorys> categoryList = [];
  List<dynamic> ordersList = [];
  List<User> usersList = [];
  List<Dish> cartList = [];
  String address;
  Order order;

  initLoginUser(User user) {
    loginUser = user;
    notifyListeners();
  }

  initUserList(user) {
    usersList = user;
    notifyListeners();
  }

  initOrder(order) {
    this.order = order;
    notifyListeners();
  }

  initDishesList(List<Dish> list) {
    dishesList = list;
    notifyListeners();
  }

  initOrderList(List<dynamic> list) {
    ordersList = list;
    notifyListeners();
  }

  initCategoryList(List<Categorys> list) {
    categoryList = list;
    notifyListeners();
  }

  addToloaded(Dish d) {
    loadeddishesList.add(d);
    notifyListeners();
  }

  addDish(Dish d) {
    dishesList.add(d);
    notifyListeners();
  }

  changeAmount(Dish dish, amount) {
    cartList[cartList.indexOf(dish)].amount = amount;
    notifyListeners();
  }

  changeAmountForDetails(amount, id) {
    order.items.firstWhere((e) => e.dish.id == id).amount = amount;
    notifyListeners();
  }

  deleteItemForDetails(id) {
    order.items.removeWhere((e) => e.dish.id == id);
    notifyListeners();
  }

  addtoCart(Dish d) {
    cartList.add(d);
    notifyListeners();
  }

  removeFromCart(Dish d) {
    cartList.remove(d);
    notifyListeners();
  }

  addtoCategory(c) {
    categoryList.add(c);
    notifyListeners();
  }

  updateCategory(Categorys c) {
    final r = categoryList.indexWhere((e) => e.id == c.id);
    categoryList[r] = c;
    notifyListeners();
  }

  updateDish(Dish d) {
    final r = dishesList.indexWhere((e) => e.id == d.id);
    dishesList[r] = d;
    notifyListeners();
  }

  updateOrder(dynamic o) {
    final r = ordersList.indexWhere((e) => e['_id'] == o['_id']);
    ordersList[r] = o;
    notifyListeners();
  }

  removeFromFav(index) {
    loginUser.fav.removeAt(index);
    notifyListeners();
  }

  removeFromFavWithId(id) {
    loginUser.fav.remove(id);
    notifyListeners();
  }

  addToFav(id) {
    loginUser.fav.add(id);
    notifyListeners();
  }

  reset() {
    cartList = [];
    address = null;
    notifyListeners();
  }
}
