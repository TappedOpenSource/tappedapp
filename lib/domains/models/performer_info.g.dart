// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformerInfo _$PerformerInfoFromJson(Map<String, dynamic> json) =>
    PerformerInfo(
      pressKitUrl: const OptionalStringConverter()
          .fromJson(json['pressKitUrl'] as String?),
      genres: (json['genres'] as List<dynamic>)
          .map((e) => $enumDecode(_$GenreEnumMap, e))
          .toList(),
      rating: optionalDoubleFromJson(json['rating']),
      reviewCount: json['reviewCount'] as int,
      label: json['label'] as String,
      spotifyId: const OptionalStringConverter()
          .fromJson(json['spotifyId'] as String?),
    );

Map<String, dynamic> _$PerformerInfoToJson(PerformerInfo instance) =>
    <String, dynamic>{
      'pressKitUrl':
          const OptionalStringConverter().toJson(instance.pressKitUrl),
      'genres': instance.genres.map((e) => _$GenreEnumMap[e]!).toList(),
      'rating': optionalDoubleToJson(instance.rating),
      'reviewCount': instance.reviewCount,
      'label': instance.label,
      'spotifyId': const OptionalStringConverter().toJson(instance.spotifyId),
    };

const _$GenreEnumMap = {
  Genre.pop: 'pop',
  Genre.rock: 'rock',
  Genre.hiphop: 'hiphop',
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
  Genre.other: 'other',
};
