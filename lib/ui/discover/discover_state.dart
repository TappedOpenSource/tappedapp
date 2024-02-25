part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<UserModel> venueHits,
    @Default([]) List<Booking> bookingHits,
    @Default([]) List<Opportunity> opportunityHits,
    @Default(MapOverlay.venues) MapOverlay mapOverlay,
    @Default([]) List<Genre> genreFilters,
    @Default(37.5407246) double userLat,
    @Default(-77.4360481) double userLng,
    LatLngBounds? bounds,
  }) = _DiscoverState;
}

@JsonEnum()
enum MapOverlay {
  venues,
  bookings,
  opportunities,
}

extension DiscoverStateX on DiscoverState {
  List<String> get genreFilterStrings {
    return genreFilters.map((e) => e.name).toList();
  }

  List<WeightedLatLng> get weightedVenueLatLngs {
    return venueHits
        .map(
          (hit) {
            final lat = hit.location.map((t) => t.lat);
            final lng = hit.location.map((t) => t.lng);

            return lat.map2(
              lng,
              (t, c) => WeightedLatLng(
                LatLng(t, c),
                1,
              ),
            );
          },
        )
        .where((element) => element.isSome())
        .map((e) => e.getOrElse(() => throw Exception()))
        .toList();
  }

  List<WeightedLatLng> get weightedBookingLatLngs {
    return bookingHits
        .map(
          (hit) {
            final lat = hit.lat;
            final lng = hit.lng;

            return lat.map2(
              lng,
              (t, c) => WeightedLatLng(
                LatLng(t, c),
                1,
              ),
            );
          },
        )
        .where((element) => element.isSome())
        .map((e) => e.getOrElse(() => throw Exception()))
        .toList();
  }

  List<WeightedLatLng> get weightedOpportunityLatLngs {
    return opportunityHits.map(
      (hit) {
        final lat = hit.location.lat;
        final lng = hit.location.lng;

        return WeightedLatLng(
          LatLng(lat, lng),
          1,
        );
      },
    ).toList();
  }
}
