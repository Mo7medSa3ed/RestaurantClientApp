import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/user.dart';

class Order {
  String id;
  User user;
  List<DishOrder> items;
  num sum;
  dynamic promo;
  String createdAt;
  String updatedAt;
  String address;
  String state;
  List<double> distLocation = [];
  List<double> deliveryLocation = [];

  Order(
      {this.id,
      this.user,
      this.address,
      this.items,
      this.promo,
      this.sum,
      this.state,
      this.distLocation,
      this.deliveryLocation,
      this.updatedAt,
      this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json['_id'],
      user: User.fromJson2(json['user']),
      items:
          List<DishOrder>.from(json['items'].map((e) => DishOrder.fromJson(e))),
      sum: json['sum'],
      state: json['state'],
      promo: json['promo'],
      address: json['address'],
      createdAt: json['createdAt'],
      deliveryLocation: List<double>.from(json['deliveryLocation']),
      distLocation: List<double>.from(json['distLocation']),
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
  factory DishOrder.fromJson(Map<String, dynamic> json) => DishOrder(
      dish: Dish.fromOneJsontoUser(json['dish']), amount: json['amount']);

  Map<String, dynamic> toJson() =>
      {'dish': dish.toJsonForUpdate(), 'amount': amount};
}
