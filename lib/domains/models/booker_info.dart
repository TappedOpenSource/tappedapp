
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils/default_value.dart';
import 'package:intheloopapp/utils/deserialize.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booker_info.g.dart';

@JsonSerializable()
class BookerInfo extends Equatable {
  const BookerInfo({
    required this.rating,
    required this.reviewCount,
  });

  @JsonKey(
    fromJson: optionalDoubleFromJson,
  )
  final Option<double> rating;

  @JsonKey(defaultValue: 0)
  final int reviewCount;

  @override
  List<Object?> get props => [
    rating,
    reviewCount,
  ];

  // empty
  factory BookerInfo.empty() => const BookerInfo(
    rating: None<double>(),
    reviewCount: 0,
  );

  // fromJson
  factory BookerInfo.fromJson(Map<String, dynamic> json) =>
      _$BookerInfoFromJson(json);

  // toJson
  Map<String, dynamic> toJson() => _$BookerInfoToJson(this);

  // copyWith
  BookerInfo copyWith({
    Option<double>? rating,
    int? reviewCount,
  }) {
    return BookerInfo(
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'rating': rating.asNullable(),
      'reviewCount': reviewCount,
    };
  }
}

class OptionalBookerInfoConverter implements JsonConverter<Option<BookerInfo>, BookerInfo?> {
  const OptionalBookerInfoConverter();

  @override
  Option<BookerInfo> fromJson(BookerInfo? value) => Option.fromNullable(value);

  @override
  BookerInfo? toJson(Option<BookerInfo> object) => object.asNullable();

}