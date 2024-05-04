class ProductModel {
  final String name;
  final String id;
  final String userId;
  final String category;
  final String quantity;
  final double price;
  final int ageYears;
  final int ageMounth;
  final String type;
  final String address;
  final List<dynamic> pictures;
  final String description;
  final String dateTime;
  final String contact;
  final String gender;

  ProductModel({
    required this.name,
    required this.id,
    required this.userId,
    required this.category,
    required this.quantity,
    required this.price,
    required this.ageYears,
    required this.ageMounth,
    required this.pictures,
    required this.description,
    required this.address,
    required this.dateTime,
    required this.contact,
    required this.gender,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'userId': userId,
      'category': category,
      'quantity': quantity,
      'price': price,
      'age_years': ageYears,
      'age_mounth': ageMounth,
      'pictures': pictures,
      'description': description,
      'address': address,
      "dateTime": dateTime.toString(),
      "contact": contact,
      "gender": gender,
      'type': type,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      name: map['name'] as String,
      id: id,
      userId: map['userId'] as String,
      category: map['category'] as String,
      quantity: map['quantity'] as String,
      price: double.parse(map['price'].toString()),
      ageYears: map["age_years"] as int,
      ageMounth: map['age_mounth'] as int,
      pictures: List<dynamic>.from((map['pictures'] as List<dynamic>)),
      description: map['description'] as String,
      address: map['address'] as String,
      dateTime: map['dateTime'] as String,
      contact: map['contact'] as String,
      gender: map['gender'] as String,
      type: map['type'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory ProductModel.fromJson(String source) =>
  //     ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
