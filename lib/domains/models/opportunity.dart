import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:json_annotation/json_annotation.dart';

part 'opportunity.g.dart';

@JsonSerializable()
class Opportunity extends Equatable {
  const Opportunity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.flierUrl,
    required this.location,
    required this.timestamp,
    required this.startTime,
    required this.endTime,
    required this.isPaid,
    required this.touched,
    required this.deleted,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);

  factory Opportunity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    return Opportunity.fromJson(data);
  }

  final String id;
  final String userId;

  @JsonKey(defaultValue: '')
  final String title;

  @JsonKey(defaultValue: '')
  final String description;

  final Option<String> flierUrl;

  @JsonKey(defaultValue: Location.rva)
  final Location location;

  @JsonKey(
    defaultValue: DateTime.now,
    fromJson: timestampToDateTime,
    toJson: dateTimeToTimestamp,
  )
  final DateTime timestamp;

  @JsonKey(
    defaultValue: DateTime.now,
    fromJson: timestampToDateTime,
    toJson: dateTimeToTimestamp,
  )
  final DateTime startTime;

  @JsonKey(
    defaultValue: DateTime.now,
    fromJson: timestampToDateTime,
    toJson: dateTimeToTimestamp,
  )
  final DateTime endTime;

  @JsonKey(defaultValue: false)
  final bool isPaid;

  final Option<OpportunityInteraction> touched;

  @JsonKey(defaultValue: false)
  final bool deleted;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        flierUrl,
        location,
        timestamp,
        startTime,
        endTime,
        isPaid,
        touched,
        deleted,
      ];

  Map<String, dynamic> toJson() => _$OpportunityToJson(this);

  Opportunity copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    Option<String>? flierUrl,
    Location? location,
    DateTime? timestamp,
    DateTime? startTime,
    DateTime? endTime,
    bool? isPaid,
    Option<OpportunityInteraction>? touched,
    bool? deleted,
  }) {
    return Opportunity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      flierUrl: flierUrl ?? this.flierUrl,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isPaid: isPaid ?? this.isPaid,
      touched: touched ?? this.touched,
      deleted: deleted ?? this.deleted,
    );
  }
}

@JsonEnum()
enum OpportunityInteraction {
  @JsonValue('like')
  like,
  @JsonValue('dislike')
  dislike,
}
