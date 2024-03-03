// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerformerInfoImpl _$$PerformerInfoImplFromJson(Map<String, dynamic> json) =>
    _$PerformerInfoImpl(
      pressKitUrl: json['pressKitUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['pressKitUrl'], (value) => value as String),
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GenreEnumMap, e))
              .toList() ??
          const [],
      rating: json['rating'] == null
          ? const None()
          : Option<double>.fromJson(
              json['rating'], (value) => (value as num).toDouble()),
      reviewCount: json['reviewCount'] as int? ?? 0,
      label: json['label'] as String? ?? 'Independent',
      spotifyUrl: json['spotifyUrl'] == null
          ? const None()
          : Option<String>.fromJson(
              json['spotifyUrl'], (value) => value as String),
    );

Map<String, dynamic> _$$PerformerInfoImplToJson(_$PerformerInfoImpl instance) =>
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
      'spotifyUrl': instance.spotifyUrl.toJson(
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
  Genre.electronic: 'electronic',
  Genre.dance: 'dance',
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
  Genre.bluegrass: 'bluegrass',
  Genre.gospel: 'gospel',
  Genre.orchestra: 'orchestra',
  Genre.theater: 'theater',
  Genre.opera: 'opera',
  Genre.other: 'other',
};
