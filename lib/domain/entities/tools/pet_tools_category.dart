import 'dart:io';

class PetToolsCategory {
  final String label;
  final String imageUrl;
  final String id;
  File? picture;
  final bool hidden;

  PetToolsCategory({
    required this.label,
    required this.imageUrl,
    required this.id,
    required this.hidden,
    this.picture,
  });
}
