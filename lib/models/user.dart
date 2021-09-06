import 'package:resturantapp/models/dish.dart';

class User {
  String id;
  String createdAt;
  String updatedAt;
  String name;
  String phone;
  String gender;
  String address;
  String location;
  String dob;
  String email;
  String img;
  String password;
  String avatar;
  List<dynamic> fav = [];
  List<Dish> history = [];

  User(
      {this.dob,
      this.email,
      this.fav,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.gender,
      this.avatar,
      this.address,
      this.img,
      this.location,
      this.history,
      this.name,
      this.password,
      this.phone});

  factory User.fromJson(Map<String, dynamic> jsondata) => User(
      id: jsondata['_id'],
      name: jsondata['name'],
      phone: jsondata['phone'],
      gender: jsondata['gender'],
      dob: jsondata['dob'],
      email: jsondata['email'],
      location: jsondata['location'],
      avatar: jsondata['avatar'],
      password: jsondata['password'],
      address: jsondata['address'],
      fav: jsondata['fav'],
      history: List<Dish>.from(
          (jsondata['history'] ?? []).map((e) => Dish.fromOneJsontoUser(e))),
      createdAt: jsondata['createdAt'],
      updatedAt: jsondata['updatedAt']);
  factory User.fromJson2(Map<String, dynamic> jsondata) => User(
      id: jsondata['_id'],
      name: jsondata['name'],
      phone: jsondata['phone'],
      gender: jsondata['gender'],
      dob: jsondata['dob'],
      email: jsondata['email'],
      location: jsondata['location'],
      avatar: jsondata['avatar'],
      address: jsondata['address'],
      createdAt: jsondata['createdAt'],
      updatedAt: jsondata['updatedAt']);

  factory User.fromJsonReview(Map<String, dynamic> jsondata) => User(
        id: jsondata['id'],
        name: jsondata['name'],
        img: jsondata['img'],
      );

  Map<String, dynamic> toJsonForReview() =>
      {'name': name, 'id': id, 'img': img};

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'gender': gender,
        'dob': dob,
        'email': email,
        'location': location,
        'address': address,
        'password': password,
        'avatar': avatar,
        'fav': fav,
        'history': history.map((e) => e.toJson()).toList()
      };

  Map<String, dynamic> toJsonForUpdate() => {
        'name': name,
        'phone': phone,
        'gender': gender,
        'address': address,
        'location': location,
        'dob': dob,
        'email': email
      };

  Map<String, dynamic> toJsonForLogin() => {
        'email': email,
        'password': password,
      };

  Map<String, dynamic> toJsonForSignup() => {
        'name': name,
        'email': email,
        'password': password,
      };
}
