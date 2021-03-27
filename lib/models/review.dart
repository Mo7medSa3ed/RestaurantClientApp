import 'package:resturantapp/models/user.dart';

class Review {
  User user;
  num rate;
  String msg;
  String id;
  String dishId;
  String createdAt;
  String updatedAt;

  Review(
      {this.msg,
      this.rate,
      this.user,
      this.id,
      this.createdAt,
      this.updatedAt});

  factory Review.fromJson(Map<String, dynamic>  json2) => Review(
      user: User.fromJsonReview(json2['user']),
      rate: json2['rate'],
      msg: json2['msg'],
      id: json2['_id'],
      updatedAt: json2['updatedAt'],
      createdAt: json2['created_at']);

  Map<String, dynamic> toJson() =>
      {'user': user.toJsonForReview(), 'rate': rate, 'msg': msg};

  Map<String, dynamic> toJsonForUpdate() =>
      {'user': user.toJsonForUpdate(), 'rate': rate, 'msg': msg, '_id': id};
}
