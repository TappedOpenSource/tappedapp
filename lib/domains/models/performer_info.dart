import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/utils/deserialize.dart';
import 'package:json_annotation/json_annotation.dart';

part 'performer_info.g.dart';

@JsonSerializable()
class PerformerInfo extends Equatable {
  const PerformerInfo({
    required this.pressKitUrl,
    required this.genres,
    required this.rating,
    required this.reviewCount,
    required this.label,
    required this.spotifyId,
  });

  // empty
  factory PerformerInfo.empty() => const PerformerInfo(
    pressKitUrl: None(),
    genres: [],
    rating: None(),
    reviewCount: 0,
    label: 'None',
    spotifyId: None(),
  );

  // fromJson
  factory PerformerInfo.fromJson(Map<String, dynamic> json) =>
      _$PerformerInfoFromJson(json);

  // @OptionalStringConverter()
  final Option<String> pressKitUrl;

  @JsonKey(defaultValue: [])
  final List<Genre> genres;

  @JsonKey(
    // toJson: optionalDoubleToJson,
    fromJson: optionalDoubleFromJson,
  )
  final Option<double> rating;

  @JsonKey(defaultValue: 0)
  final int reviewCount;

  @JsonKey(defaultValue: 'None')
  final String label;

  // @OptionalStringConverter()
  final Option<String> spotifyId;

  @override
  List<Object> get props => [
    pressKitUrl,
    genres,
    rating,
    reviewCount,
    label,
    spotifyId,
  ];

  // copyWith
  PerformerInfo copyWith({
    Option<String>? pressKitUrl,
    List<Genre>? genres,
    Option<double>? rating,
    int? reviewCount,
    String? label,
    Option<String>? spotifyId,
  }) {
    return PerformerInfo(
      pressKitUrl: pressKitUrl ?? this.pressKitUrl,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      label: label ?? this.label,
      spotifyId: spotifyId ?? this.spotifyId,
    );
  }

  // toJson
  Map<String, dynamic> toJson() => _$PerformerInfoToJson(this);

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'pressKitUrl': pressKitUrl.toNullable(),
      'genres': genres.map((e) => e.name).toList(),
      'rating': rating.toNullable(),
      'reviewCount': reviewCount,
      'label': label,
      'spotifyId': spotifyId.toNullable(),
    };
  }
}

class OptionalPerformerInfoConverter implements JsonConverter<Option<PerformerInfo>, PerformerInfo?> {
  const OptionalPerformerInfoConverter();

  @override
  Option<PerformerInfo> fromJson(PerformerInfo? value) => Option.fromNullable(value);

  @override
  PerformerInfo? toJson(Option<PerformerInfo> option) => option.toNullable();
}