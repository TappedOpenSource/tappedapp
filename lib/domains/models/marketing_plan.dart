import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/default_value.dart';

class MarketingPlan {
  const MarketingPlan({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.content,
    required this.prompt,
    required this.timestamp,
  });

  factory MarketingPlan.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp = doc.getOrElse(
        'timestamp',
        Timestamp.now(),
      );

      return MarketingPlan(
        id: doc.id,
        userId: doc.get('userId') as String,
        name: doc.getOrElse('name', ''),
        type: EnumToString.fromString(
              MarketingPlanType.values,
              doc.get('type') as String,
            ) ??
            MarketingPlanType.single,
        content: doc.get('content') as String,
        prompt: doc.get('prompt') as String,
        timestamp: tmpTimestamp.toDate(),
      );
    } catch (e, s) {
      logger.error(
        'Error building loop from doc',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  final String id;
  final String userId;
  final String name;
  final MarketingPlanType type;
  final String content;
  final String prompt;
  final DateTime timestamp;

  MarketingPlan copyWith({
    String? id,
    String? userId,
    String? name,
    MarketingPlanType? type,
    String? content,
    String? prompt,
    DateTime? timestamp,
  }) {
    return MarketingPlan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      content: content ?? this.content,
      prompt: prompt ?? this.prompt,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

enum MarketingPlanType {
  single,
}
