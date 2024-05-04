// ignore_for_file: constant_identifier_names, prefer_typing_uninitialized_variables

class FavModel {
  //constant
  static const String NAME = 'name';
  static const String ID = 'id';
  static const String CATEGORY = 'category';
  static const String BRAND = 'brand';
  static const String QUANTITY = 'quantity';
  static const String PRICE = 'price';
  static const String SIZE = 'size';
  static const String PICTURES = 'pictures';
  static const String FEATURED = "featured";
  static const String DESCRIPTION = "description";

  //private variables

  String? _name;
  String? _id;
  String? _category;
  String? _brand;
  String? _quantity;
  var _price;
  List<dynamic>? _size;
  List<dynamic>? _pictures;
  bool? _featured;
  String? _description;

  //getters

  String get name => _name!;
  String get id => _id!;
  String get category => _category!;
  String get brand => _brand!;
  String get quantity => _quantity!;
  get price => _price;
  List<dynamic> get size => _size!;
  List<dynamic> get pictures => _pictures!;
  bool get featured => _featured!;
  String get description => _description!;

  FavModel.fromMap(Map<String, dynamic> data) {
    _name = data[NAME];
    _id = data[ID];
    _category = data[CATEGORY];
    _brand = data[BRAND];
    _quantity = data[QUANTITY];
    _price = data[PRICE];
    _size = data[SIZE];
    _pictures = data[PICTURES];
    _featured = data[FEATURED];
    _description = data[DESCRIPTION];
  }
  Map toMap() => {
        NAME: _name,
        ID: _id,
        CATEGORY: _category,
        BRAND: _brand,
        QUANTITY: _quantity,
        PRICE: _price,
        SIZE: _size,
        PICTURES: _pictures,
        FEATURED: _featured,
        DESCRIPTION: _description
      };

  FavModel.fromSnapshot(Map<String, dynamic> snapshot) {
    _id = snapshot[ID];
    _name = snapshot[NAME];
    _category = snapshot[CATEGORY];
    _brand = snapshot[BRAND];
    _quantity = snapshot[QUANTITY];
    _price = snapshot[PRICE];
    _size = snapshot[SIZE];
    _pictures = snapshot[PICTURES];
    _featured = snapshot[FEATURED];
    _description = snapshot[DESCRIPTION];
  }
}
