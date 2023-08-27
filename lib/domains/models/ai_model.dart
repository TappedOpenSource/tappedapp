import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intheloopapp/utils/default_value.dart';

sealed class AiModel {
  const AiModel({
    required this.id,
    required this.userId,
    required this.type,
  });

  factory AiModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final type = EnumToString.fromString(
          AiModelType.values,
          doc.getOrElse('type', 'image'),
        ) ??
        AiModelType.image;

    return switch (type) {
      AiModelType.image => AiImageModel(
          id: doc.id,
          userId: doc.get('userId') as String,
          type: AiModelType.image,
        ),
      AiModelType.text => throw UnimplementedError(),
    };
  }

  final String id;
  final String userId;
  final AiModelType type;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': EnumToString.convertToString(type),
    };
  }
}

class AiImageModel extends AiModel {
  const AiImageModel({
    required super.id,
    required super.userId,
    required super.type,
  });
}

enum AiModelType {
  image,
  text,
}
