import 'package:flutter/foundation.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/home.dart';
import 'package:resturantapp/models/order.dart';
import 'package:resturantapp/models/user.dart';

class AppData extends ChangeNotifier {
  User loginUser;
  List<Dish> favDishes = [];
  List<Dish> historyDishes = [];
  List<Dish> topDishes = [];
  List<Dish> popularDishes = [];
  List<dynamic> ordersList = [];
  List<dynamic> dishesByCategory = [];
  List<Dish> cartList = [];
  HomeModel homeModel = HomeModel();
  String address;
  Order detailsOrder;

  initLoginUser(User user) {
    loginUser = user;
    notifyListeners();
  }

  initOrder(detailsOrder) {
    this.detailsOrder = detailsOrder;
    notifyListeners();
  }

  initHomeModel(homeModel) {
    this.homeModel = homeModel;
    notifyListeners();
  }

  initFavDishesList(List<Dish> list) {
    favDishes = list;
    notifyListeners();
  }

  initHistoryDishesList(List<Dish> list) {
    historyDishes= list;
    notifyListeners();
  }

  initOrderList(List<dynamic> list) {
    ordersList.addAll(list);
    notifyListeners();
  }

  clearAllOrderList() {
    ordersList.clear();
    notifyListeners();
  }

  initTopDishesList(List<Dish> list) {
    topDishes.addAll(list);
    notifyListeners();
  }

  clearTopDishesList() {
    topDishes.clear();
    notifyListeners();
  }
  initDishesByCategory (List<Dish> list) {
    dishesByCategory.addAll(list);
    notifyListeners();
  }

  clearDishesByCategory() {
    dishesByCategory.clear();
    notifyListeners();
  }

  initpopularDishesList(List<Dish> list) {
    popularDishes.addAll(list);
    notifyListeners();
  }

  clearpopularDishesList() {
    popularDishes.clear();
    notifyListeners();
  }

  addDish(Dish d) {
    favDishes.add(d);
    notifyListeners();
  }

  changeAmount(Dish dish, amount) {
    cartList[cartList.indexOf(dish)].amount = amount;
    notifyListeners();
  }

  changeAmountForDetails(amount, id) {
    detailsOrder.items.firstWhere((e) => e.dish.id == id).amount = amount;
    notifyListeners();
  }

  deleteItemForDetails(id) {
    detailsOrder.items.removeWhere((e) => e.dish.id == id);
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
