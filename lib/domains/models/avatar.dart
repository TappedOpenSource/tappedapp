import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils/default_value.dart';

class Avatar {
  Avatar({
    required this.id,
    required this.userId,
    required this.prompt,
    required this.imageUrl,
    required this.inferenceId,
  });

  factory Avatar.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Avatar(
      id: doc.id,
    userId: doc.get('userId') as String,
      prompt: doc.get('prompt') as String,
      imageUrl: doc.get('imageUrl') as String,
      inferenceId: doc.get('inferenceId') as String,
    );
  }

  String id;
  String userId;
  String prompt;
  String imageUrl;
  String inferenceId;
}
