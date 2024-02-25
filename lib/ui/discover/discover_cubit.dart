import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/genre.dart';

import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/debouncer.dart';
import 'package:latlong2/latlong.dart';

part 'discover_state.dart';

part 'discover_cubit.freezed.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit({
    required this.search,
    required this.initGenres,
  }) : super(
          DiscoverState(
            genreFilters: initGenres,
          ),
        );

  final SearchRepository search;
  final List<Genre> initGenres;

  final _debouncer = Debouncer(
    const Duration(milliseconds: 150),
    executionInterval: const Duration(milliseconds: 500),
  );

  Future<(double, double)> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      final position = await Future.any([
        Geolocator.getCurrentPosition(),
        Future.delayed(const Duration(seconds: 2), () => null),
      ]);
      return (
        position?.latitude ?? Location.nyc.lat,
        position?.longitude ?? Location.nyc.lng,
      );
    } catch (e) {
      return (Location.nyc.lat, Location.nyc.lng);
    }
  }

  Future<(double, double)> initLocation() async {
    final (lat, lng) = await _determinePosition();
    final hits = await getVenues(
      lat: lat,
      lng: lng,
    );
    emit(
      state.copyWith(
        venueHits: hits,
        userLat: lat,
        userLng: lng,
      ),
    );

    return (lat, lng);
  }

  void toggleGenreFilter(Genre genre) {
    final genres = List<Genre>.from(state.genreFilters);
    if (genres.contains(genre)) {
      genres.remove(genre);
    } else {
      genres.add(genre);
    }

    onBoundsChange(
      state.bounds,
      overlay: state.mapOverlay,
    );

    emit(
      state.copyWith(
        genreFilters: genres,
        mapOverlay: state.mapOverlay,
      ),
    );
  }

  Future<List<UserModel>> getVenues({
    double? lat,
    double? lng,
  }) async {
    final hits = await search.queryUsers(
      '',
      occupations: ['Venue', 'venue'],
      venueGenres: state.genreFilterStrings.isNotEmpty
          ? state.genreFilterStrings
          : null,
      lat: lat,
      lng: lng,
    );
    return hits;
  }

  Future<List<Booking>> getBookings({
    double? lat,
    double? lng,
  }) async {
    final hits = await search.queryBookings(
      '',
      lat: lat,
      lng: lng,
    );
    return hits;
  }

  Future<List<Opportunity>> getOpportunities({
    double? lat,
    double? lng,
  }) async {
    final hits = await search.queryOpportunities(
      '',
      lat: lat,
      lng: lng,
    );
    return hits;
  }

  void onMapOverlayChange(MapOverlay overlay) {
    onBoundsChange(
      state.bounds,
      overlay: overlay,
    );
    emit(state.copyWith(mapOverlay: overlay));
  }

  void onBoundsChange(
    LatLngBounds? bounds, {
    MapOverlay? overlay,
  }) {
    if (bounds == null) return;

    final mapType = overlay ?? state.mapOverlay;

    emit(
      state.copyWith(
        bounds: bounds,
      ),
    );

    _debouncer.run(
      switch (mapType) {
        MapOverlay.venues => () async {
            final hits = await search.queryUsersInBoundingBox(
              '',
              occupations: ['Venue', 'venue'],
              venueGenres: state.genreFilterStrings.isNotEmpty
                  ? state.genreFilterStrings
                  : null,
              swLatitude: bounds.southWest.latitude,
              swLongitude: bounds.southWest.longitude,
              neLatitude: bounds.northEast.latitude,
              neLongitude: bounds.northEast.longitude,
            );
            emit(state.copyWith(venueHits: hits));
          },
        MapOverlay.bookings => () async {
            final hits = await search.queryBookingsInBoundingBox(
              '',
              swLatitude: bounds.southWest.latitude,
              swLongitude: bounds.southWest.longitude,
              neLatitude: bounds.northEast.latitude,
              neLongitude: bounds.northEast.longitude,
            );
            emit(state.copyWith(bookingHits: hits));
          },
        MapOverlay.opportunities => () async {
            final hits = await search.queryOpportunitiesInBoundingBox(
              '',
              swLatitude: bounds.southWest.latitude,
              swLongitude: bounds.southWest.longitude,
              neLatitude: bounds.northEast.latitude,
              neLongitude: bounds.northEast.longitude,
            );
            emit(state.copyWith(opportunityHits: hits));
          },
      },
    );
  }
}
