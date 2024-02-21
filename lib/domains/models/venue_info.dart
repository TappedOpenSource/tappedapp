import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/domains/models/genre.dart';

part 'venue_info.freezed.dart';
part 'venue_info.g.dart';

@freezed
class VenueInfo with _$VenueInfo {
  const factory VenueInfo({
    @Default(None()) Option<String> bookingEmail,
    @Default(None()) Option<String> autoReply,
    @Default(None()) Option<int> capacity,
    @Default(None()) Option<String> idealPerformerProfile,
    @Default([]) List<Genre> genres,
    @Default([]) List<String> venuePhotos,
    @Default(None()) Option<String> productionInfo,
    @Default(None()) Option<String> frontOfHouse,
    @Default(None()) Option<String> monitors,
    @Default(None()) Option<String> microphones,
    @Default(None()) Option<String> lights,
    @Default(VenueType.other) VenueType type,
  }) = _VenueInfo;

  // fromJson
  factory VenueInfo.fromJson(Map<String, dynamic> json) =>
      _$VenueInfoFromJson(json);

  // empty
  static const empty = VenueInfo();
}

@JsonEnum()
enum VenueType {
  concertHall,
  bar,
  club,
  restaurant,
  theater,
  arena,
  stadium,
  festival,
  artGallery,
  studio,
  brewery,
  hotel,
  other,
}

extension VenueTypeX on VenueType {
  String get formattedName {
    return switch (this) {
      VenueType.concertHall => 'Concert Hall',
      VenueType.bar => 'Bar',
      VenueType.club => 'Club',
      VenueType.restaurant => 'Restaurant',
      VenueType.theater => 'Theater',
      VenueType.arena => 'Arena',
      VenueType.stadium => 'Stadium',
      VenueType.festival => 'Festival',
      VenueType.artGallery => 'Art Gallery',
      VenueType.studio => 'Studio',
      VenueType.brewery => 'Brewery',
      VenueType.hotel => 'Hotel',
      VenueType.other => 'Other',
    };
  }
}
