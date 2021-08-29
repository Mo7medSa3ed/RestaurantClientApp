import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/models/review.dart';

class Dish {
  String id;
  String img;
  String name;
  String desc;
  num price;
  num rating;
  dynamic category;
  num numOfPieces;
  List<dynamic> reviews;

  String updatedAt;
  int amount = 1;

  Dish(
      {this.desc,
      this.id,
      this.img,
      this.name,
      this.numOfPieces,
      this.price,
      this.rating,
      this.category,
      this.reviews,
      this.updatedAt});

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
      id: json['_id'],
      img: json['img'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      category: Categorys.fromJson(json['category']),
      reviews: json['reviews'],
      rating: json['rating'],
      numOfPieces: json['numOfPieces'],
      updatedAt: json['updatedAt']);

  factory Dish.fromOneJson(Map<String, dynamic> json2) => Dish(
      id: json2['_id'],
      img: json2['img'],
      name: json2['name'],
      desc: json2['desc'],
      price: json2['price'],
      category: json2['category'],
      rating: json2['rating'],
      reviews:
          List<Review>.from(json2['reviews'].map((e) => Review.fromJson(e)))
              .toList(),
      numOfPieces: json2['numOfPieces'],
      updatedAt: json2['updatedAt']);
  factory Dish.fromJsonForHome(Map<String, dynamic> json2) => Dish(
        id: json2['_id'],
        img: json2['img'],
        name: json2['name'],
        desc: json2['desc'],
        price: json2['price'],
        category: json2['category'],
        rating: json2['rating'],
        numOfPieces: json2['numOfPieces'],
        updatedAt: json2['updatedAt'],
      );

  factory Dish.fromOneJsontoUser(Map<String, dynamic> json2) => Dish(
      id: json2['_id'],
      img: json2['img'],
      name: json2['name'],
      desc: json2['desc'],
      price: json2['price'],
      category: json2['category'],
      rating: json2['rating'],
      reviews: List<String>.from(json2['reviews']),
      numOfPieces: json2['numOfPieces'],
      updatedAt: json2['updatedAt']);

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'img': img,
        'name': name,
        'desc': desc,
        'price': price,
        'rating': rating,
        'numOfPieces': numOfPieces,
        'reviews': reviews.map((e) => e.toJsonForUpdate()).toList()
      };

  Map<String, dynamic> toJson() => {
        'img': img,
        'name': name,
        'desc': desc,
        'price': price,
        'rating': rating,
        'numOfPieces': numOfPieces,
        //'reviews': reviews.map((e) => e.toJson()).toList()
      };
}
