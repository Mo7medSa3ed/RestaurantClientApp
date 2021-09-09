class Categorys {
  String id;
  String createdAt;
  String updatedAt;
  String name;
  String img;
  num numOfDishes;

  Categorys(
      {this.img,
      this.name,
      this.numOfDishes,
      this.id,
      this.createdAt,
      this.updatedAt});

  factory Categorys.fromJson(Map<String, dynamic> json) => Categorys(
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],
      img: json['img'],
      numOfDishes: json['numOfDishes']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'img': img,
        'numOfDishes': numOfDishes,
        "_id": id,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };

  Map<String, dynamic> toJsonForUpdate() =>
      {'name': name, 'img': img, 'numOfDishes': numOfDishes, '_id': id};
}
