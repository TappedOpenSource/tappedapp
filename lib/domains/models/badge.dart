import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge extends Equatable {
  const Badge({
    required this.id,
    required this.creatorId,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.timestamp,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  factory Badge.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
    return Badge(
      id: doc.id,
      creatorId: doc.getOrElse('creatorId', ''),
      imageUrl: doc.getOrElse('imageUrl', ''),
      name: doc.getOrElse('name', ''),
      description: doc.getOrElse('description', ''),
      timestamp: tmpTimestamp.toDate(),
    );
  }
  final String id;
  final String creatorId;
  final String imageUrl;
  final String name;
  final String description;
  final DateTime timestamp;

  @override
  List<Object> get props => [
        id,
        creatorId,
        imageUrl,
        name,
        description,
        timestamp,
      ];
  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  Badge copyWith({
    String? id,
    String? creatorId,
    String? imageUrl,
    String? name,
    String? description,
    DateTime? timestamp,
  }) {
    return Badge(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatorId': creatorId,
      'imageUrl': imageUrl,
      'name': name,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
