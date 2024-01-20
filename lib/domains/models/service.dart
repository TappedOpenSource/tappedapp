import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
    final data = doc.data();
    if (data == null) {
      throw Exception('Document does not exist!');
    }

    return Service.fromJson(data);
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

  @JsonKey(defaultValue: '')
  final String title;

  @JsonKey(defaultValue: '')
  final String description;

  @JsonKey(defaultValue: 0)
  final int rate;

  @JsonKey(defaultValue: RateType.hourly)
  final RateType rateType;

  @JsonKey(defaultValue: 0)
  final int count;

  @JsonKey(defaultValue: false)
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
