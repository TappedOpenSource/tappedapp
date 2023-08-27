import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils/default_value.dart';

class Avatar {
  Avatar({
    required this.id,
    required this.userId,
    required this.prompt,
    required this.imageUrl,
    required this.inferenceId,
    required this.timestamp,
  });

  factory Avatar.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
      final tmpTimestamp = doc.getOrElse(
        'timestamp',
        Timestamp.now(),
      );

    return Avatar(
      id: doc.id,
    userId: doc.get('userId') as String,
      prompt: doc.get('prompt') as String,
      imageUrl: doc.get('imageUrl') as String,
      inferenceId: doc.get('inferenceId') as String,
      timestamp: tmpTimestamp.toDate(),
    );
  }

  String id;
  String userId;
  String prompt;
  String imageUrl;
  String inferenceId;
  DateTime timestamp;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'prompt': prompt,
      'imageUrl': imageUrl,
      'inferenceId': inferenceId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
