import 'package:flutter/foundation.dart';
import 'package:resturantapp/models/categorys.dart';
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
  List<Dish> dishesByCategory = [];
  List<Dish> cartList = [];
  HomeModel homeModel = HomeModel();
  String address;
  Order detailsOrder;
  Order trackOrder;

  initTrackOrder(order) {
    trackOrder = order;
    notifyListeners();
  }

  initLoginUser(User user) {
    loginUser = user;
    notifyListeners();
  }

  changeRateForHome({String id, num rate}) {
    final idx = (homeModel.popular ?? []).indexWhere((e) => e.id == id);
    if (idx != -1) {
      homeModel.popular[idx].rating = rate;
    }
    final idx2 = (homeModel.topRate ?? []).indexWhere((e) => e.id == id);
    if (idx2 != -1) {
      if (rate == 0) {
        homeModel.topRate.removeAt(idx2);
      } else {
        homeModel.topRate[idx2].rating = rate;
      }
    }

    if (favDishes.length > 0) {
      final idx3 = favDishes.indexWhere((e) => e.id == id);
      if (idx3 != -1) {
        favDishes[idx3].rating = rate;
      }
    }

    notifyListeners();
  }

  initOrder(detailsOrder) {
    this.detailsOrder = detailsOrder;
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
    historyDishes = list;
    notifyListeners();
  }

  initOrderList(List<dynamic> list) {
    ordersList = list;
  }

  clearOrder(id) {
    ordersList.removeWhere((e) => e['_id'] == id);
    notifyListeners();
  }

  getCategoryById(id) {
    return homeModel.categories.firstWhere((e) => e.id == id).toJson();
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
    // notifyListeners();
  }

  initDishesByCategory(List<Dish> list) {
    dishesByCategory.addAll(list);
    notifyListeners();
  }

  changeOrderState(id, state) {
    final idx = ordersList.indexWhere((e) => e['_id'] == id);
    if (idx != -1) {
      ordersList[idx]['state'] = state;
    }
    notifyListeners();
  }

  clearDishesByCategory() {
    dishesByCategory.clear();
    // notifyListeners();
  }

  initpopularDishesList(List<Dish> list) {
    popularDishes.addAll(list);
    notifyListeners();
  }

  clearpopularDishesList() {
    popularDishes.clear();
    // notifyListeners();
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

  removeFromFavWithDish(id) {
    favDishes.removeWhere((e) => e.id == id);
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

  // methodes to sockets

  addNewDish(Dish dish) {
    // popularDishes.add(dish);
    // homeModel.popular.add(dish);
    if (dishesByCategory.length > 0) {
      if (dishesByCategory.first.category.id == dish.category.id) {
        dishesByCategory.add(dish);
      }
    }
    notifyListeners();
  }

  updateDish(Dish dish) {
    if (topDishes.length > 0) {
      final idx = topDishes.indexWhere((e) => e.id == dish.id);
      if (idx != -1) topDishes[idx] = dish;
    }
    if (popularDishes.length > 0) {
      final idx = popularDishes.indexWhere((e) => e.id == dish.id);
      if (idx != -1) popularDishes[idx] = dish;
    }
    if (favDishes.length > 0) {
      final idx = favDishes.indexWhere((e) => e.id == dish.id);
      if (idx != -1) favDishes[idx] = dish;
    }
    if (historyDishes.length > 0) {
      final idx = historyDishes.indexWhere((e) => e.id == dish.id);
      if (idx != -1) historyDishes[idx] = dish;
    }
    if (dishesByCategory.length > 0) {
      final idx = dishesByCategory.indexWhere((e) => e.id == dish.id);
      if (idx != -1) dishesByCategory[idx] = dish;
    }
    if (homeModel.popular.length > 0) {
      final idx = homeModel.popular.indexWhere((e) => e.id == dish.id);
      if (idx != -1) homeModel.popular[idx] = dish;
    }
    if (homeModel.topRate.length > 0) {
      final idx = homeModel.topRate.indexWhere((e) => e.id == dish.id);
      if (idx != -1) homeModel.topRate[idx] = dish;
    }
    notifyListeners();
  }

  removeDish(id) {
    if (topDishes.length > 0) {
      topDishes.removeWhere((e) => e.id == id);
    }
    if (popularDishes.length > 0) {
      popularDishes.removeWhere((e) => e.id == id);
    }
    if (favDishes.length > 0) {
      favDishes.removeWhere((e) => e.id == id);
    }
    if (historyDishes.length > 0) {
      historyDishes.removeWhere((e) => e.id == id);
    }
    if (dishesByCategory.length > 0) {
      dishesByCategory.removeWhere((e) => e.id == id);
    }
    if (homeModel.popular.length > 0) {
      homeModel.popular.removeWhere((e) => e.id == id);
    }
    if (homeModel.topRate.length > 0) {
      homeModel.topRate.removeWhere((e) => e.id == id);
    }
    notifyListeners();
  }

  addCategory(Categorys category) {
    homeModel.categories.add(category);
    notifyListeners();
  }

  updateCategory(Categorys category) {
    if (homeModel.categories.length > 0) {
      final idx = homeModel.categories.indexWhere((e) => e.id == category.id);
      if (idx != -1) homeModel.categories[idx] = category;
      notifyListeners();
    }
  }

  removeCategory(id) {
    if (homeModel.categories.length > 0) {
      homeModel.categories.removeWhere((e) => e.id == id);
    }
    notifyListeners();
  }

  updateOrder(order) {
    if (trackOrder.id == order['_id']) {
      trackOrder = Order.fromJson(order);
      notifyListeners();
    }
    if (ordersList.length > 0) {
      ordersList.removeWhere((e) => e['_id'] == order['_id']);
      notifyListeners();
    }
  }

  updateOrderLocation(order) {
    if (trackOrder.id == order['_id']) {
      trackOrder = Order.fromJson(order);
      notifyListeners();
    }
  }
}
