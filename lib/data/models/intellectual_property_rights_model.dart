
  
import '../../domain/entities/intellectual_property_rights/intellectual_property_rights.dart';

class IntellectualPropertyRightsModel extends IntellectualPropertyRights{
  const IntellectualPropertyRightsModel({required super.id,required super.text});
    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'id': id,
    };
  }

  factory IntellectualPropertyRightsModel.fromMap(Map<String, dynamic> map) {
    return IntellectualPropertyRightsModel(
      text: map['text'] as String, 
      id: map['_id'] as String, 
    );
  }
}
