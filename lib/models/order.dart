import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/user.dart';

class Order {
  String id;
  User user;
  List<DishOrder> items;
  num sum;
  num promo;
  String createdAt;
  String updatedAt;
  String address;
  String state;

  Order(
      {this.id,
      this.user,
      this.address,
      this.items,
      this.promo,
      this.sum,
      this.state,
      this.updatedAt,
      this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json['_id'],
      user: User.fromJson(json['user']),
      items:
          List<DishOrder>.from(json['items'].map((e) => DishOrder.fromJson(e))),
      sum: json['sum'],
      promo: json['promo'],
      address: json['address'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']);

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'user': user,
        'items': items.map((e) => e.toJson()).toList(),
        'sum': sum,
        'promo': promo,
        'address': address
      };

  Map<String, dynamic> toJson() => {
        'user': user,
        'items': items.map((e) => e.toJson()).toList(),
        'sum': sum,
        'promo': promo,
        'address': address
      };
}

class DishOrder {
  Dish dish;
  num amount;

  DishOrder({this.amount, this.dish});
  factory DishOrder.fromJson(Map<String, dynamic> json) =>
      DishOrder(dish: Dish.fromOneJson(json['dish']), amount: json['amount']);

  Map<String, dynamic> toJson() =>
      {'dish': dish.toJsonForUpdate(), 'amount': amount};
}
