import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String creatorId,
    required String imageUrl,
    required String name,
    required String description,
    @DateTimeConverter() required DateTime timestamp,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  factory Badge.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    data['id'] = doc.id;

    return Badge.fromJson(data);
  }
}
