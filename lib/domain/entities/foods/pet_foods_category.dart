import 'dart:io';

class PetFoodsCategory {
  final String label;
  final String imageUrl;
  final String id;
  File? picture;
  final bool hidden;

  PetFoodsCategory({
    required this.label,
    required this.imageUrl,
    required this.id,
    required this.hidden,
    this.picture,
  });
}
