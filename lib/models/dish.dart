import 'package:resturantapp/models/review.dart';

class Dish {
  String id;
  String img;
  String name;
  String desc;
  num price;
  num rating;
  String category;
  num numOfPieces;
  List<Review> reviews;
  List<String> review;

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
      this.review,
      this.reviews,
      this.updatedAt});

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
      id: json['_id'],
      img: json['img'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      category: json['category'],
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
      );

  factory Dish.fromOneJsontoUser(Map<String, dynamic> json2) => Dish(
        id: json2['_id'],
        img: json2['img'],
        name: json2['name'],
        desc: json2['desc'],
        price: json2['price'],
        category: json2['category'],
        rating: json2['rating'],
        review: List<String>.from(json2['reviews']),
        numOfPieces: json2['numOfPieces'],
      );

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
