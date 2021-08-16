import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/models/dish.dart';

class HomeModel {
  List<Dish> popular = [];
  List<Dish> topRate = [];
  List<Categorys> categories = [];

  HomeModel({this.categories, this.popular, this.topRate});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
      categories: List<Categorys>.from(
          json['categories'].map((e) => Categorys.fromJson(e))),
      popular:
          List<Dish>.from(json['popular'].map((e) => Dish.fromJsonForHome(e))),
      topRate:
          List<Dish>.from(json['topRate'].map((e) => Dish.fromJsonForHome(e))));
}
