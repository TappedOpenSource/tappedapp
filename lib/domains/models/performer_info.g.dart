// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformerInfo _$PerformerInfoFromJson(Map<String, dynamic> json) =>
    PerformerInfo(
      pressKitUrl: Option<String>.fromJson(
          json['pressKitUrl'], (value) => value as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GenreEnumMap, e))
              .toList() ??
          [],
      rating: optionalDoubleFromJson(json['rating']),
      reviewCount: json['reviewCount'] as int? ?? 0,
      label: json['label'] as String? ?? 'None',
      spotifyId: Option<String>.fromJson(
          json['spotifyId'], (value) => value as String),
    );

Map<String, dynamic> _$PerformerInfoToJson(PerformerInfo instance) =>
    <String, dynamic>{
      'pressKitUrl': instance.pressKitUrl.toJson(
        (value) => value,
      ),
      'genres': instance.genres.map((e) => _$GenreEnumMap[e]!).toList(),
      'rating': instance.rating.toJson(
        (value) => value,
      ),
      'reviewCount': instance.reviewCount,
      'label': instance.label,
      'spotifyId': instance.spotifyId.toJson(
        (value) => value,
      ),
    };

const _$GenreEnumMap = {
  Genre.pop: 'pop',
  Genre.rock: 'rock',
  Genre.hiphop: 'hiphop',
  Genre.rap: 'rap',
  Genre.rnb: 'rnb',
  Genre.country: 'country',
  Genre.edm: 'edm',
  Genre.jazz: 'jazz',
  Genre.latin: 'latin',
  Genre.classical: 'classical',
  Genre.reggae: 'reggae',
  Genre.blues: 'blues',
  Genre.soul: 'soul',
  Genre.funk: 'funk',
  Genre.metal: 'metal',
  Genre.punk: 'punk',
  Genre.indie: 'indie',
  Genre.folk: 'folk',
  Genre.alternative: 'alternative',
  Genre.other: 'other',
};
