import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:resturantapp/models/categorys.dart';
import 'package:resturantapp/models/dish.dart';
import 'package:resturantapp/models/home.dart';
import 'package:resturantapp/models/review.dart';
import 'dart:convert';
import 'package:resturantapp/models/user.dart';

class API {
  static const String _BaseUrl = 'https://resturant-app12.herokuapp.com';

  // Functions For User

  static Future<dynamic> loginUser(User user) async {
    final response = await http.post('$_BaseUrl/users/auth/login',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(user.toJsonForLogin()));
    return response;
  }

  static Future<dynamic> signupUser(User user) async {
    final res = await http.post('$_BaseUrl/users/',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(user.toJsonForSignup()));
    return res;
  }

  static updateImage(File image, String id) async {
    String name = image.path.split('/').last;
    FormData form = FormData.fromMap(
        {'avatar': await MultipartFile.fromFile(image.path, filename: name)});
    Dio dio = new Dio();
    await dio.post('$_BaseUrl/users/change/avatar/$id', data: form);
  }

  static Future<dynamic> updateUser(User user, id) async {
    final res = await http.patch('$_BaseUrl/users/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(user.toJsonForUpdate()));
    return res;
  }

  static Future<dynamic> getOneUser(String id) async {
    final response = await http.get('$_BaseUrl/users/$id');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);

      return {"status": true, "data": User.fromJson(parsed)};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getAllUser() async {
    final response = await http.get('$_BaseUrl/users/');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body).cast<Map<String, dynamic>>();
      return {
        "status": true,
        "data": parsed.map<User>((dish) => User.fromJson2(dish)).toList()
      };
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getFavOrHis({fav, id}) async {
    final response = await http.get(
        '$_BaseUrl/users/details/$id?${fav ? 'detail=fav' : 'detail=history'}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return {
        "status": true,
        "data": parsed.map<Dish>((dish) => Dish.fromJson(dish)).toList()
      };
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> searchForDish(query) async {
    final response = await http.get('$_BaseUrl/dishes/filter/name?name=$query');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return {
        "status": true,
        "data": parsed['dishes']
            .map<Dish>((dish) => Dish.fromJsonForHome(dish))
            .toList()
      };
    } else {
      return {"status": false, "data": null};
    }
  }

  // Function For Dish

  static Future<dynamic> getAllDishes({top, page}) async {
    final res = await http.get(
      '$_BaseUrl/dishes/filter/query?${top ? 'topRate=true' : 'popular=true'}&&page=$page',
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {
        "status": true,
        "data": parsed['dishes']
            .map<Dish>((dish) => Dish.fromJsonForHome(dish))
            .toList()
      };
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getAllDishesByCategory(String id, {page}) async {
    final res = await http.get(
      '$_BaseUrl/dishes/category/$id?page=$page',
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {
        "status": true,
        "data": parsed['dishes']
            .map<Dish>((dish) => Dish.fromJsonForHome(dish))
            .toList()
      };
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<Map<String, dynamic>> getHome() async {
    final res = await http.get(
      '$_BaseUrl/stats/home',
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {"status": true, "data": HomeModel.fromJson(parsed)};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getOneDish(String id) async {
    final res = await http.get(
      '$_BaseUrl/dishes/$id',
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {"status": true, "data": Dish.fromOneJson(parsed)};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> deleteDish(String dishId) async {
    final res = await http.delete(
      '$_BaseUrl/dishes/$dishId',
    );
    return res;
  }

  static updateImageForDish(PickedFile image, String id) async {
    String name = image.path.split('/').last;
    FormData form = FormData.fromMap(
        {'img': await MultipartFile.fromFile(image.path, filename: name)});
    Dio dio = new Dio();
    await dio.patch('$_BaseUrl/dishes/change-img/$id', data: form);
  }

  static Future<dynamic> updateDish(
      String id, Map<String, dynamic> updatedDish) async {
    final res = await http.patch('$_BaseUrl/dishes/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(updatedDish));
    return res;
  }

  // Function For reviews
  static Future<dynamic> addReview(Review review, String id) async {
    final res = await http.post('$_BaseUrl/dishes/reviews/add/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(review.toJson()));
    return res;
  }

  static Future<dynamic> deleteReview(String dishId, String reviewid) async {
    final res = await http.delete(
      '$_BaseUrl/reviews?dishId=$dishId&reviewId=$reviewid',
    );
    return res;
  }

  static Future<dynamic> updateReview(
      Review review, String dishId, String reviewid) async {
    final res = await http.patch(
        '$_BaseUrl/reviews/1?dishId=$dishId&reviewId=$reviewid',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(review.toJson()));
    return res;
  }

  // function For favourite

  static Future<dynamic> addanddelteFav(String userid, String dishid) async {
    final res = await http.post('$_BaseUrl/users/fav/$userid',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode({"dishId": dishid}));
    return res;
  }

  // function for orders

  static Future<dynamic> makeOrder(Map<String, dynamic> order) async {
    final res = await http.post('$_BaseUrl/orders/',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(order));

    return res;
  }

  // function for categories
  static Future<dynamic> getAllCategories() async {
    final res = await http.get(
      '$_BaseUrl/categories',
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {
        "status": true,
        "data":
            parsed.map<Categorys>((dish) => Categorys.fromJson(dish)).toList()
      };
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> deleteCategory(String name) async {
    final res = await http.delete(
      '$_BaseUrl/categories/$name',
    );
    return res;
  }

  static Future<dynamic> addCategory(Map<String, dynamic> categories) async {
    final res = await http.post('$_BaseUrl/categories/',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(categories));
    return res;
  }

  static Future<dynamic> updateCategory(
      Map<String, dynamic> categories, id) async {
    final res = await http.patch('$_BaseUrl/categories/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(categories));
    return res;
  }

  static Future<dynamic> patchOrder(Map<String, dynamic> order, id) async {
    final res = await http.patch('$_BaseUrl/orders/$id',
        encoding: Encoding.getByName("utf-8"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(order));

    return res;
  }

  static Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=AIzaSyBMD6TqYt-Y0dc4grEFzBmCkHOqsKncgAo";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values.toString(); //;
  }

  static Future<dynamic> getAllOrders({page, state}) async {
    final res = await http.get(
      '$_BaseUrl/orders/state/${state.toString().toLowerCase()}',
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);
      return {"status": true, "data": parsed};
    } else {
      return {"status": false, "data": null};
    }
  }

  static Future<dynamic> getOneOrder(id) async {
    final res = await http.get(
      '$_BaseUrl/orders/$id',
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = utf8.decode(res.bodyBytes);
      final parsed = json.decode(body);

      return {"status": true, "data": parsed};
    } else {
      return {"status": false, "data": null};
    }
  }
}
