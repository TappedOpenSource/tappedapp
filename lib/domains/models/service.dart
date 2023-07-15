import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends Equatable {
  const Service({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.rate,
    required this.rateType,
    required this.count,
    required this.deleted,
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  factory Service.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Service(
      id: doc.id,
      userId: doc.getOrElse('userId', ''),
      title: doc.getOrElse('title', ''),
      description: doc.getOrElse('description', ''),
      rate: doc.getOrElse('rate', 0),
      rateType: EnumToString.fromString(
            RateType.values,
            doc.getOrElse('rateType', ''),
          ) ??
          RateType.hourly,
      count: doc.getOrElse('count', 0),
      deleted: doc.getOrElse('deleted', false),
    );
  }

  factory Service.empty() => Service(
        id: const Uuid().v4(),
        userId: '',
        title: '',
        description: '',
        rate: 0,
        rateType: RateType.hourly,
        count: 0,
        deleted: false,
      );

  final String id;
  final String userId;
  final String title;
  final String description;
  final int rate;
  final RateType rateType;
  final int count;
  final bool deleted;

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  List<Object> get props => [
        id,
        userId,
        title,
        description,
        rate,
        rateType,
        count,
        deleted,
      ];

  Service copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    int? rate,
    RateType? rateType,
    int? count,
    bool? deleted,
  }) {
    return Service(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      rateType: rateType ?? this.rateType,
      count: count ?? this.count,
      deleted: deleted ?? this.deleted,
    );
  }
}

enum RateType {
  @JsonValue('hourly')
  hourly,

  @JsonValue('fixed')
  fixed,
}
