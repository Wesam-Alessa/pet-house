import 'dart:io';

class PetCategory {
  final String label;
  final String imageUrl;
  final String id;
  File? picture;
  final bool hidden;
  PetCategory(
      {required this.label,
      required this.imageUrl,
      required this.id,
      required this.hidden,
      this.picture});
}
